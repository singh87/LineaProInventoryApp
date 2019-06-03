//
//  @objc dynamic var swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/15/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Product: Object {
    
    @objc dynamic var itemNum: String?
    @objc dynamic var itemName: String?
    let cost = RealmOptional<Double>()
    let price = RealmOptional<Double>()
    let retail_price = RealmOptional<Double>()
    @objc dynamic var tax_1: String?
    @objc dynamic var altSku: String?
    @objc dynamic var dept_id: String?
    @objc dynamic var itemName_extra: String?
    @objc dynamic var count_this_item: String?
    @objc dynamic var print_on_receipt: String?
    @objc dynamic var allowReturns: String?
    
    override static func primaryKey() -> String?{
        return "itemNum"
    }
}
