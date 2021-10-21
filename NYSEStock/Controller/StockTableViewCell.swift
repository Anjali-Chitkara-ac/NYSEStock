//
//  StockTableViewCell.swift
//  NYSEStock
//
//  Created by Anjali Chitkara on 10/14/21.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSymbol: UILabel!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
