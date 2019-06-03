//
//  AppDelegate.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/13/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import RealmSwift
import InfineaSDK

public var localRealmConfig = Realm.Configuration(
    
    fileURL: Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent("localInventory.realm")
)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    lazy var managedObjectContext : NSManagedObjectContext = {
//        return self.persistentContainer.viewContext
//    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let ipc = IPCIQ.register()
        ipc?.setDeveloperKey("2XsH9di9YRyEj3SA6VJI75PFhhnTJILg1GK386nr2KFmatjNdQE+8YfcTQ+TCgawUNZhWlA2w7kRZ8W6cDURow==")
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            print("not preloaded")
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
    }

    
 
    func parseCSV (contentsOfURL: URL, encoding: String.Encoding, error: ErrorPointer) -> [(itemNum:String, itemName:String, cost: String, price: String, retail_price: String, tax_1: String, altSku: String, dept_id: String, itemName_extra: String, count_this_item: String, print_on_receipt: String, allowReturns: String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(itemNum:String, itemName:String, cost: String, price: String, retail_price: String, tax_1: String, altSku: String, dept_id: String, itemName_extra: String, count_this_item: String, print_on_receipt: String, allowReturns: String)]?
        var content:String = ""
        do{
            content = try String(contentsOf: contentsOfURL, encoding: String.Encoding.utf8)
        } catch {
            print("Unexpected error: \(error).")
        }
        print(content)
        
        if !content.isEmpty {
            items = []
            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (itemNum: values[0], itemName: values[1], cost: values[2], price: values[3], retail_price: values[4], tax_1: values[5], altSku: values[6], dept_id: values[7], itemName_extra: values[8], count_this_item: values[9], print_on_receipt: values[10], allowReturns: values[11])
                    items?.append(item)
                    print(item)
                }
            }
        }
        
        return items
    }
    
    func preloadData () {
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.url(forResource: "items", withExtension: "csv") {

//            // Remove all the menu items before preloading
//            removeData()

            var error:NSError?
            if let items = parseCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                // Preload the menu items
                let realm = try! Realm()
                for item in items {
                    let product = Product()

                    product.itemNum = item.itemNum
                    product.itemName = item.itemName
                    product.cost.value = Double(item.cost) ?? 0
                    product.price.value = Double(item.price) ?? 0
                    product.retail_price.value = Double(item.retail_price) ?? 0
                    product.tax_1 = item.tax_1
                    product.altSku = item.altSku
                    product.dept_id = item.dept_id
                    product.itemName_extra = item.itemName_extra
                    product.count_this_item = item.count_this_item
                    product.print_on_receipt = item.print_on_receipt
                    product.allowReturns = item.allowReturns

                    do{
                        try realm.write {
                            realm.add(product)
                        }
                    } catch let error as NSError {
                        print("Error: \(error), \(error.userInfo)")
                    }
                }

            }
        }
    }
}

