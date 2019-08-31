//
//  SoldOutInvestmentTableViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 26/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class SoldOutInvestmentTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var investment: Investment! {
        didSet {
            typeLabel.text = investment.type?.uppercased()
            productNameLabel.text = investment.title
            descriptionLabel.text = """
            \((investment.price ?? 0).commaSeparatedNairaValue)
            \(investment.yield!)% in \(investment.duration!) months
            """
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
