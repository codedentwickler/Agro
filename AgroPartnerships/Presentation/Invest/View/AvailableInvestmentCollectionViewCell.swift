//
//  AvailableInvestmentCollectionViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Cards
import Kingfisher

class AvailableInvestmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var yieldInMonthsLabel: UILabel!

    var investment: Investment! {
        didSet {
            typeLabel.text = investment.type?.uppercased()
            productNameLabel.text = investment.title!.capitalized
            amountLabel.text = (investment.price ?? 0).commaSeparatedNairaValue
            yieldInMonthsLabel.text = "\(investment.yield!)% in \(investment.duration!) months"
            loadImage()
        }
    }
    
    private func loadImage() {
        let url = URL(string: investment.picture!)
        let processor = DownsamplingImageProcessor(size: imageView.frame.size) >> RoundCornerImageProcessor(cornerRadius: 10)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
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
                self.imageView.backgroundColor = UIColor.clear
                 AgroLogger.log("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                 AgroLogger.log("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
