//
//  OtherCommoditiesCollectionViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 28/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Cards

class OtherCommoditiesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewButton: UIView!
    @IBOutlet var backgroundCard: Card!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var yieldInMonthsLabel: UILabel!
    
    var investment: Investment! {
        didSet {
            typeLabel.text = investment.type?.capitalizeFirstLetter()
            productNameLabel.text = investment.title
            amountLabel.text = investment.price?.commaSeparatedValue
            yieldInMonthsLabel.text = "\(investment.yield!)% in \(investment.duration!) months"
        }
    }
}
