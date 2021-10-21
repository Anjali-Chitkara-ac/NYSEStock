//
//  StockTableViewController.swift
//  NYSEStock
//
//  Created by Anjali Chitkara on 10/13/21.
//

import UIKit
import RealmSwift
import SwiftyJSON
import SwiftSpinner
import Alamofire
import PromiseKit

class StockTableViewController: UITableViewController {
    
    let stockQuoteURL = "https://financialmodelingprep.com/api/v3/quote-short/"
    let companyProfileURL = "https://financialmodelingprep.com/api/v3/profile/"
    let apiKey = "ff43fa116bfd506dd19ea0b5127dce8d"
    
    var arr = ["abcd","efgh"]
    

    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStockValues()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
        
//        do{
//            print(Realm.Configuration.defaultConfiguration.fileURL)
//        } catch {
//            print("Error in getting values from db \(error)")
//        }

    }
    
    @objc func refreshData(){
        loadStockValues()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    //on pressing "+"
    @IBAction func addStock(_ sender: Any) {
        
        var globalTextField: UITextField?
        
        let actionController = UIAlertController(title: "Add stock symbol", message: "", preferredStyle: .alert)
        
        let OKButton = UIAlertAction(title: "OK", style: .default) { action in
            print("Stock Typed = \(globalTextField?.text)")
            guard let symbol = globalTextField?.text else {
                return
            }
            
            if symbol == "" {
                return
            }
            self.storeValuesInDb(symbol.uppercased())
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default) { action in
            print("I am in cancel")
        }
        
        actionController.addAction(OKButton)
        actionController.addAction(cancelButton)
        
        actionController.addTextField { stockTextField in
            stockTextField.placeholder = "Stock Symbol"
            globalTextField = stockTextField
        }
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    func storeValuesInDb(_ symbol : String){
        print(symbol)
        
        getCompanyInfo(symbol)
            .done { companyJSON in

                if companyJSON.count == 0 {
                    return
                }

                let companyInfo = CompanyInfo()
                companyInfo.symbol = companyJSON["symbol"].stringValue
                companyInfo.price = companyJSON["price"].floatValue
                companyInfo.volAvg = companyJSON["volAvg"].intValue
                companyInfo.companyName = companyJSON["companyName"].stringValue
                companyInfo.exchangeShortName = companyJSON["exchangeShortName"].stringValue
                companyInfo.website = companyJSON["website"].stringValue
                companyInfo.desc = companyJSON["description"].stringValue
                companyInfo.image = companyJSON["image"].stringValue
                
                //print(companyInfo)

                self.addStockInDB(companyInfo)

            }
            .catch{ (error) in
                print(error)
            }
    }
    

    
    func addStockInDB(_ companyInfo : CompanyInfo){
        do{
            let realm = try Realm()
            try realm.write({
                realm.add(companyInfo, update: .modified)
            })
        } catch {
            print("Error in getting values from db \(error)")
        }
        
    }
    
    func getCompanyInfo(_ symbol : String) -> Promise <JSON> {
        
        return Promise< JSON > { seal -> Void in
            
            let url = companyProfileURL + symbol + "?apikey=" + apiKey
                        
            AF.request(url).responseJSON { response in
        
                if response.error != nil {
                    seal.reject(response.error!)
                }
                
                let stocks = JSON( response.data!).array
            
                guard let firstStock = stocks!.first else { seal.fulfill(JSON())
                    return
                }
                
                seal.fulfill(firstStock)
                
            }// AF Response JSON
        }// Promise return
    }// End of function
    
    func loadStockValues(){

            do{
                let realm = try Realm()
                let companies = realm.objects(CompanyInfo.self)

                arr.removeAll()

                for company in companies{
                    arr.append( "\(company.symbol) \(company.companyName)" )
                }


            }catch{
                print("Error in reading Database \(error)")
            }

    }
        
}
