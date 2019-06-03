//
//  ProductAddPopupViewController.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/20/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit

class ProductAddPopupViewController: UIViewController {
    
    var barcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func popup_confirmButton(_ sender: UIButton) {

        guard let pa_vc = storyboard?.instantiateViewController(withIdentifier: "ProductAddViewController") as! ProductAddViewController? else{
            return
        }
        pa_vc.barcode = barcode
        guard let navigationVC = self.navigationController else { return }
        navigationVC.popToRootViewController(animated: false)
        navigationVC.pushViewController(pa_vc, animated: false)
    

    }
    
    @IBAction func popup_cancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    

}
