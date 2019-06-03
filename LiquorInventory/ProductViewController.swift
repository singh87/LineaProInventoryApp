//
//  ProductViewController.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/15/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import RealmSwift


class ProductViewController: UIViewController{
    
    var itemNum = ""
    var product = Product()
    @IBOutlet var p_image: UIImageView!
    @IBOutlet var p_name: UILabel!
    @IBOutlet var p_price: UILabel!
    @IBOutlet var p_add_button: UIButton!
    @IBOutlet var p_remove_button: UIButton!
    @IBAction func p_add(_ sender: UIButton) {
        
        let defaultRealm = try! Realm()
        let localRealm = try! Realm(configuration: localRealmConfig)
        if(product.count_this_item == "False"){
            
                if(localRealm.object(ofType: Product.self, forPrimaryKey: product.itemNum) != nil){
                    sender.isEnabled = false
                    sender.setTitle("Already in List.", for: UIControl.State.normal)
                    sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
                }else{
                    try! localRealm.write {
                        updateDefaultRealm(count: true)
                        localRealm.create(Product.self, value: product)
                        
                        sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
                        sender.setTitle("Added to List", for: UIControl.State.normal)
                        navigationItem.rightBarButtonItem?.isEnabled = true
                    }
                }
            
            
        }else{
            sender.isEnabled = false
            sender.setTitle("Already in List.", for: UIControl.State.normal)
            sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
        }
            
            
//        else{
//            sender.isEnabled = false
//            sender.setTitle("Already added!", for: UIControl.State.normal)
//            sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
//        }
        }
    @IBAction func p_remove(_ sender: UIButton) {
        if(product.count_this_item=="True"){
            let realm = try! Realm(configuration: localRealmConfig)
            let updatedProduct = realm.objects(Product.self).filter("itemNum = %@", product.itemNum)
            do{
                updateDefaultRealm(count: false)
                try! realm.write {
                    let obj = realm.object(ofType: Product.self, forPrimaryKey: product.itemNum)
                    realm.delete(obj!)
                }
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
            sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
            sender.setTitle("Removed from List", for: UIControl.State.normal)
        }else{
            sender.isEnabled = false
            sender.setTitle("Already removed!", for: UIControl.State.normal)
            sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p_image.image = UIImage(named: String(itemNum))
        print(p_image.image)
        print(String(itemNum))

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let realm = try! Realm()
        let localRealm = try! Realm(configuration: localRealmConfig)
        product = realm.objects(Product.self).filter("itemNum = %@", itemNum).first ?? Product()
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProduct))
        if product.count_this_item == "True"{
            let local_product = localRealm.object(ofType: Product.self, forPrimaryKey: product.itemNum)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.p_add_button.isHidden = true
            p_name.text = local_product!.itemName
            p_price.text = local_product!.price.value?.description
            //p_remove_button.isHidden = false
        }else{
            self.p_remove_button.isHidden = true
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            p_name.text = product.itemName
            p_price.text = product.price.value?.description
            //p_add_button.isHidden = false
        }
        
    }

    @objc func editProduct(){
        if let evc = storyboard?.instantiateViewController(withIdentifier: "ProductEditViewController") as? ProductEditViewController{
            let localRealm = try! Realm(configuration: localRealmConfig)
            let local_product = localRealm.object(ofType: Product.self, forPrimaryKey: product.itemNum)
            evc.product = local_product!
            navigationController?.pushViewController(evc,animated: true)

        }

    }
    
    func updateDefaultRealm(count:Bool){
        let defaultRealm = try! Realm()
        if(count){
            try! defaultRealm.write{
                product.count_this_item = "True"
                defaultRealm.add(product, update: true)
            }
        }else{
            try! defaultRealm.write{
                product.count_this_item = "False"
                defaultRealm.add(product, update: true)
            }
        }
        
    }
}
