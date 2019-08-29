//
//  ProvideInvestmentDetailsModalViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 28/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class ProvideInvestmentDetailsModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func userPressedNext(_ sender: Any) {
        let vc = viewController(type: ProvideInvestmentDetailsModalViewController.self,
                                from: StoryBoardIdentifiers.Invest)
        navigationController?.pushViewController(vc, animated: true)
    }
}
