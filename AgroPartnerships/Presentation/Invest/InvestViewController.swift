//
//  InvestViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class InvestViewController: BaseViewController {

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet weak var availableInvestmentsCollectionView: UICollectionView!
    @IBOutlet weak var soldOutInvestmentsTableView: UITableView!
    @IBOutlet weak var soldOutInvestmentsTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userPressedSeeAllAvailableInvestments(_ sender: Any) {
    }
    
    @IBAction func userPressedSeeAllSoldOutInvestments(_ sender: Any) {
    }
}
