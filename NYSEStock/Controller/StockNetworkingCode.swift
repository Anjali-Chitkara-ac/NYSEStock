//
//  StockRealmCode.swift
//  NYSEStock
//
//  Created by Anjali Chitkara on 10/14/21.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import SwiftSpinner
import Alamofire
import PromiseKit

extension StockTableViewController {
    
    func doesStockExistInDB(_ symbol : String) -> Bool{
        do{
            let realm = try Realm()
            if realm.object(ofType: CompanyInfo.self, forPrimaryKey: symbol) != nil{
                return true
            }
        } catch {
            print("Error in getting values from db \(error)")
        }
        
        return false
    }
    
}
