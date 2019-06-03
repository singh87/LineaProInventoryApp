//
//  ViewController.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/13/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import RealmSwift
import InfineaSDK

let searchController = UISearchController(searchResultsController: nil)
var lineaState:Int32 = 0
class ViewController: UIViewController, UISearchBarDelegate, IPCDTDeviceDelegate, UITextFieldDelegate {
    @IBOutlet var s_bar: UISearchBar!
    let scanner = IPCDTDevices.sharedDevice()
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        s_bar.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner?.addDelegate(self)
//        scanner?.setAutoOffWhenIdle(TimeInterval(5000), whenDisconnected: TimeInterval(5000))
//        mode: Int32
//        scanner?.barcodeSetTypeMode(mode)
        
        scanner?.connect()
        
        
        let realm = try! Realm()
        self.hideKeyboardWhenTappedAround()
        print(Realm.Configuration.defaultConfiguration.fileURL)

    
    }

    @IBAction func scanButton(_ sender: Any) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let id = searchBar.text
        let defaultRealm = try! Realm()
        let localRealm = try! Realm(configuration: localRealmConfig)
        print("itemNum = " + id!)
        
        if(localRealm.object(ofType: Product.self, forPrimaryKey: id) != nil){
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController? else{
                return
            }
            guard let itemNum = id else {
                return
            }
            vc.itemNum = itemNum
            navigationController?.popToRootViewController(animated: false)
            navigationController?.pushViewController(vc, animated: true)
        }else if(defaultRealm.object(ofType: Product.self, forPrimaryKey: id) != nil){
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController? else{
                return
            }
            guard let itemNum = id else {
                return
            }
            vc.itemNum = itemNum
            navigationController?.popToRootViewController(animated: false)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let popup = storyboard?.instantiateViewController(withIdentifier: "ProductAddPopupViewController") as! ProductAddPopupViewController? else{
                return
            }
            popup.barcode = searchBar.text!
            searchBar.text = nil
            self.navigationController?.pushViewController(popup, animated: false)
        }
        
        
    }
//    func applicationDidEnterBackground(_ application: UIApplication) {
//
//        scanner.disconnect()
//
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//
//        scanner.connect()
//
//    }

    func barcodeData(_ barcode: String!, type: Int32) {
        s_bar.text = barcode
        searchBarSearchButtonClicked(s_bar)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       let inverseSet = NSCharacterSet(charactersIn:"0123456789\n").inverted
        
        let components = text.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")
        
        if filtered == text {
            return true
        } else {
            return false
        }
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
