//
//  InvestmentDescriptionViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 10/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class InvestmentDescriptionViewController: BaseViewController {
    
    public var investment: Investment!
    @IBOutlet weak var investmentDescriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        investmentDescriptionTextView.text = investment.description
    }
}
