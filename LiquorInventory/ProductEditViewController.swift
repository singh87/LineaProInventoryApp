//
//  ProductEditViewController.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/16/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import RealmSwift


class ProductEditViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var saved_label: UILabel!
    @IBOutlet var p_nameTextField: CustomTextField!
    @IBOutlet var p_priceTextField: CustomTextField!
    enum TextFieldTags: Int{
        case Name = 1, Price
    };
    var barcode = ""
    var product = Product()
    override func viewDidLoad() {
        super.viewDidLoad()
        p_nameTextField.delegate = self
        self.p_nameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        p_priceTextField.delegate = self
        p_nameTextField.tag = TextFieldTags.Name.rawValue
        p_priceTextField.tag = TextFieldTags.Price.rawValue
        p_priceTextField.keyboardType = UIKeyboardType.decimalPad
        p_nameTextField.text = product.itemName
        let price = product.price.value!
        
        p_priceTextField.text = String(price)
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProduct))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func saveProduct(){
        let realm = try! Realm(configuration: localRealmConfig)
        let updatedProduct = realm.objects(Product.self).filter("itemNum = %@", product.itemNum)
        
        if let updatedProduct = updatedProduct.first{
            try! realm.write {
                updatedProduct.price.value = Double(p_priceTextField.text!)
                updatedProduct.itemName = p_nameTextField.text
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.saved_label.isHidden = false
            self.saved_label.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.saved_label.isHidden = true
                self.saved_label.alpha = 1.0
                })

        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        
        return true
    }
}
extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
