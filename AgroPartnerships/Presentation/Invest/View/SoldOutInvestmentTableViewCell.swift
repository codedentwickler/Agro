//
//  SoldOutInvestmentTableViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 26/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Kingfisher

class SoldOutInvestmentTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var investment: Investment! {
        didSet {
            typeLabel.text = investment.type?.uppercased()
            productNameLabel.text = investment.title?.capitalized
            descriptionLabel.text = """
            \((investment.price ?? 0).commaSeparatedNairaValue)
            \(investment.yield!)% in \(investment.duration!) months
            """
            loadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func loadImage() {
        let url = URL(string: investment.picture!)
        let processor = DownsamplingImageProcessor(size: iconImageView.frame.size) >> RoundCornerImageProcessor(cornerRadius: 10)

        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]){
            result in
            switch result {
            case .success(let value):
                self.iconImageView.backgroundColor = UIColor.clear
                 AgroLogger.log("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                 AgroLogger.log("Job failed: \(error.localizedDescription)")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
