//
//  LandingViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 11/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Cards

class LandingViewController: BaseViewController {

    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var dashboardCard: Card!
    @IBOutlet weak var investCard: Card!
    @IBOutlet weak var aboutCard: Card!
    @IBOutlet weak var helpdeskCard: Card!
    @IBOutlet weak var profileCard: Card!
    @IBOutlet weak var settingsCard: Card!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardsEvents()
    }
    
    private func setupCardsEvents() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(showDashboard))
        dashboardCard.isUserInteractionEnabled = true
        dashboardCard.addGestureRecognizer(tap)
    }
    
    @objc func showDashboard() {
        let vc = viewController(type: DashboardTabBarController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        present(vc, animated: true, completion: nil)
    }
}
