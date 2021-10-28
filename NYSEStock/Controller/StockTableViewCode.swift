//
//  StockTableViewCode.swift
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

extension  StockTableViewController {
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompanyInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let company = arrCompanyInfo[indexPath.row]
        //cell.textLabel?.text = "\(company.symbol) \(company.companyName) $\(company.price)"
        
        let cell = Bundle.main.loadNibNamed("StockTableViewCell", owner: self, options: nil)?.first as! StockTableViewCell
        cell.lblSymbol.text = arrCompanyInfo[indexPath.row].symbol
        cell.lblCompanyName.text = arrCompanyInfo[indexPath.row].companyName
        cell.lblPrice.text = "$ \(arrCompanyInfo[indexPath.row].price)"
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            arrCompanyInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //for details page/segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        compantDetail = arrCompanyInfo[indexPath.row]
        performSegue(withIdentifier: "SegueDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="SegueDetails"){
            let detalisVC = segue.destination as! DetailsViewController
            detalisVC.companyInfo = compantDetail
        }
    }
    
}
