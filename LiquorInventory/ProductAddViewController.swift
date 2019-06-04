//
//  ProductAddViewController.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/20/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import RealmSwift
class ProductAddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var p_barcode: UITextField!
    @IBOutlet var p_itemName: CustomTextField!
    @IBOutlet var p_itemPrice: CustomTextField!
    @IBOutlet var p_deptId: CustomTextField!
    enum TextFieldTags: Int{
        case Name = 1, Price
    };
    var barcode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        p_barcode.text = barcode
        p_itemPrice.delegate = self
        p_itemPrice.keyboardType = UIKeyboardType.decimalPad
        p_deptId.delegate = self
        self.p_deptId.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        p_itemName.delegate = self
        self.p_itemName.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        p_itemPrice.tag = TextFieldTags.Price.rawValue
        p_itemName.tag = TextFieldTags.Name.rawValue
        p_itemName.addTarget(self, action: #selector(giveFeedback), for: .editingChanged)
        p_itemPrice.addTarget(self, action: #selector(giveFeedback), for: .editingChanged)
        p_deptId.addTarget(self, action: #selector(giveFeedback), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProduct))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func giveFeedback(_ sender: CustomTextField){
        if sender.text == ""{
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }else{
            sender.backgroundColor = UIColor.white
        }
        
    }

    @objc func saveProduct(){
        let realm = try! Realm(configuration: localRealmConfig)
        let product = Product()
        product.itemNum = barcode
        product.itemName = p_itemName.text
        product.price.value = Double(p_itemPrice.text!)
        product.dept_id = p_deptId.text
        product.altSku = ""
        product.cost.value = 0.00
        product.itemName_extra = "."
        product.print_on_receipt = "True"
        product.allowReturns = "True"
        product.tax_1 = "True"
        product.retail_price.value = 0.00
        product.count_this_item = "True"
        
        
        try! realm.write {
            realm.add(product, update: true)
            print("added")
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case TextFieldTags.Name.rawValue:
            return true
        case TextFieldTags.Price.rawValue:
            let inverseSet = NSCharacterSet(charactersIn:"0123456789\n").inverted
            
            let components = string.components(separatedBy: inverseSet)
            
            let filtered = components.joined(separator: "")
            
            if filtered == string {
                return true
            } else {
                if string == "." {
                    let countdots = textField.text!.components(separatedBy:".").count - 1
                    if countdots == 0 {
                        return true
                    }else{
                        if countdots > 0 && string == "." {
                            return false
                        } else {
                            return true
                        }
                    }
                }else{
                    return false
                }
            }
        default:
            return true
        }
        
    }

}
