//
//  DetailsViewController.swift
//  NYSEStock
//
//  Created by Anjali Chitkara on 10/27/21.
//

import UIKit

class DetailsViewController: UIViewController {

    var companyInfo : CompanyInfo?
    
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSymbol.text = companyInfo?.symbol
        lblPrice.text = "$ \(companyInfo?.price)"
        lblCompanyName.text = companyInfo?.companyName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
