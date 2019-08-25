//
//  CreditCardCollectionViewCell.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class CreditCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedIndicatorImageView: UIImageView!
    @IBOutlet weak var cardbackgroud: UIImageView!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var card: CreditCard! {
        didSet {
            cardNumberLabel.text = card.last4
            cardTypeLabel.text = "\(card.bank ?? "") \u{2022} \(card.cardType?.capitalizeFirstLetter() ?? "")"
        }
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                setSelected()
            }
            else{
                setDeselected()
            }
        }
    }
    
    fileprivate func setDeselected() {
        UIView.animate(withDuration: 0.25) {
           self.selectedIndicatorImageView.image = UIImage(named: "credit-unselected-icon")
        }
    }
    
    fileprivate func setSelected() {
        UIView.animate(withDuration: 0.25) {
            self.selectedIndicatorImageView.image = UIImage(named: "credit-selection-icon")

        }
    }
}
