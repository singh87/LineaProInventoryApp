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
        let localRealm = try! Realm(configuration: localRealmConfig)
        let local_product = localRealm.object(ofType: Product.self, forPrimaryKey: itemNum)
        if(local_product != nil && local_product?.count_this_item == "True"){
            sender.isEnabled = false
            sender.setTitle("Already in List.", for: UIControl.State.normal)
            sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
        }else if(local_product != nil && local_product?.count_this_item == "False"){
            try! localRealm.write {
                local_product?.count_this_item = "True"
            }
            sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
            sender.setTitle("Added to List", for: UIControl.State.normal)
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            try! localRealm.write {
                localRealm.create(Product.self, value: product)
                sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
                sender.setTitle("Added to List", for: UIControl.State.normal)
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
            
            
//        else{
//            sender.isEnabled = false
//            sender.setTitle("Already added!", for: UIControl.State.normal)
//            sender.setTitleColor(UIColor.red, for: UIControl.State.normal)
//        }
        }
    @IBAction func p_remove(_ sender: UIButton) {
        let localRealm = try! Realm(configuration: localRealmConfig)
        if(localRealm.object(ofType: Product.self, forPrimaryKey: itemNum)?.count_this_item == "True") {
            
            do{
                try localRealm.write {
                    let obj = localRealm.object(ofType: Product.self, forPrimaryKey: itemNum)
                    obj?.count_this_item = "False"
                }
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
            sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
            sender.setTitle("Removed from List", for: UIControl.State.normal)
        }else {
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
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProduct))
        let local_product = localRealm.object(ofType: Product.self, forPrimaryKey: itemNum)
        
        if local_product != nil && local_product?.count_this_item == "True"{
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.p_add_button.isHidden = true
            p_name.text = local_product!.itemName
            p_price.text = local_product!.price.value?.description
            //p_remove_button.isHidden = false
        }else if local_product != nil && local_product?.count_this_item == "False"{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.p_remove_button.isHidden = true
            p_name.text = local_product!.itemName
            p_price.text = local_product!.price.value?.description
        
        }else{
            product = realm.objects(Product.self).filter("itemNum = %@", itemNum).first ?? Product()
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
            let local_product = localRealm.object(ofType: Product.self, forPrimaryKey: itemNum)
            evc.product = local_product!
            navigationController?.pushViewController(evc,animated: true)

        }

    }
    
}
