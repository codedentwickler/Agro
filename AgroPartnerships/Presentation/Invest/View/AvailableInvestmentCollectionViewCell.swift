//
//  AvailableInvestmentCollectionViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Cards

class AvailableInvestmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet var backgroundCard: Card!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var yieldInMonthsLabel: UILabel!

    var investment: Investment! {
        didSet {
            typeLabel.text = investment.type?.uppercased()
            productNameLabel.text = investment.title!
            amountLabel.text = (investment.price ?? 0).commaSeparatedNairaValue
            yieldInMonthsLabel.text = "\(investment.yield!)% in \(investment.duration!) months"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
