//
//  StockInfo.swift
//  NYSEStock
//
//  Created by Anjali Chitkara on 10/7/21.
//

import Foundation
import RealmSwift

class CompanyInfo : Object {
    
    @objc dynamic var symbol : String = ""
    @objc dynamic var price : Float = 0.0
    @objc dynamic var volAvg : Int = 0
    @objc dynamic var companyName : String = ""
    @objc dynamic var exchangeShortName : String = ""
    @objc dynamic var website : String = ""
    @objc dynamic var desc : String = ""
    @objc dynamic var image : String = ""
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
    
}
