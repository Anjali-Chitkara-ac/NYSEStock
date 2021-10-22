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
    
    var arrCompanyInfo : [CompanyInfo] = [CompanyInfo]()
    

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
    
//    override func viewDidAppear(_ animated: Bool) {
//        loadStockValues()
//    }
    
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
            self.storeValuesInDB(symbol.uppercased())
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
    
    func storeValuesInDB(_ symbol : String ){
            
            getCompanyInfo(symbol)
                .done { company in
                    self.addStockInDB(company)
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
    
    func getCompanyInfo(_ symbol : String) -> Promise<CompanyInfo>{
            return Promise<CompanyInfo> { seal -> Void in
                let url = companyProfileURL + symbol + "?apikey=" + apiKey
                
                AF.request(url).responseJSON { response in
                    
                    if response.error != nil {
                        seal.reject(response.error!)
                    }
                    
                    let stocks = JSON( response.data!).array
                    
                    guard let firstStock = stocks!.first else { seal.fulfill(CompanyInfo())
                        return
                    }
                    
                    let companyInfo = CompanyInfo()
                    companyInfo.symbol = firstStock["symbol"].stringValue
                    companyInfo.price = firstStock["price"].floatValue
                    companyInfo.volAvg = firstStock["volAvg"].intValue
                    companyInfo.companyName = firstStock["companyName"].stringValue
                    companyInfo.exchangeShortName = firstStock["exchangeShortName"].stringValue
                    companyInfo.website = firstStock["website"].stringValue
                    companyInfo.desc = firstStock["description"].stringValue
                    companyInfo.image = firstStock["image"].stringValue
                    
                    seal.fulfill(companyInfo)
                    
                }
            }
        }// End of getCompanyInfo
    
    func getAllCompanyInfo(_ companies: [CompanyInfo] ) -> Promise<[CompanyInfo]> {
            
            var promises: [Promise< CompanyInfo >] = []
            
            for i in 0 ... companies.count - 1 {
                promises.append( getCompanyInfo(companies[i].symbol) )
            }
            
            return when(fulfilled: promises)
            
   }
    
    func loadStockValues(){
            
            do{
                let realm = try Realm()
                let companies = realm.objects(CompanyInfo.self)
             
                arrCompanyInfo.removeAll()
                
                getAllCompanyInfo(Array(companies)).done { companiesInfo in
                    self.arrCompanyInfo.append(contentsOf: companiesInfo)
                    //self.arrSearch.append(contentsOf: companiesInfo)
                    self.tblView.reloadData()
                }
                .catch { error in
                    print(error)
                }
                
                
                
            }catch{
                print("Error in reading Database \(error)")
            }
            
        }
        
}
