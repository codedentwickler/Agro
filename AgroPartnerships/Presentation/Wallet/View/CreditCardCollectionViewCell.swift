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

    var card : String! {
        didSet {
            
        }
    }
}
