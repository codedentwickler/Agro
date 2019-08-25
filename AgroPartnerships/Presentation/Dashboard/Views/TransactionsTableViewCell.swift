//
//  TransactionsTableViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 19/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    @IBOutlet weak var grayDotView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    
    var transaction : Transactions! {
        didSet {
            if transaction.category != ApiConstants.FundWallet {
                rootView.backgroundColor = UIColor(hex: "#F8F8F8", a: 0.08)
                iconImageView.image = UIImage(named: "red-arrow-down")
            }
            amountLabel.text = transaction.amount?.commaSeparatedValue
            descriptionLabel.text = transaction.description
            dateLabel.text = transaction.date?.asFullDate(format: "E - d MMM, yyyy")
        }
    }
}
