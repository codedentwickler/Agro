//
//  PendingInvestmentTableViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 19/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class PendingInvestmentTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var returnsLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var yieldDateLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    public var portfolio : Portfolio! {
        didSet {
            titleLabel.text = portfolio.investment?.title
            subtitleLabel.text = "\(portfolio.code!) ‒‒ \(portfolio.investment?.price?.commaSeparatedNairaValue ?? "")/unit"
            returnsLabel.text = "\(portfolio.yield ?? 0)%"
            unitsLabel.text = portfolio.units?.commaSeparatedNairaValue
            amountLabel.text = portfolio.amount?.commaSeparatedNairaValue
            typeLabel.text = portfolio.investment?.type?.uppercased()
            startDateLabel.text = portfolio.startDate?.asFullDate(format: "EEEE\nMMM d, yyyy")
            yieldDateLabel.text = portfolio.endDate?.asFullDate(format: "EEEE\nMMM d, yyyy")
        }
    }
}
