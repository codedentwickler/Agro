//
//  CardCollectionViewCell.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 31/3/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit

class DashboardCardCollectionViewCell: CardCollectionViewCell {

    @IBOutlet weak var dashbordCardContentView: DashboardCardContentView!
    
    override func awakeFromNib() {
        cardContentView = dashbordCardContentView
        super.awakeFromNib()
    }
}
