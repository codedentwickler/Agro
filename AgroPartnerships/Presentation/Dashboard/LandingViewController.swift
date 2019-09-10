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
    
    public var dashboardInformation: DashboardResponse?

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
        
        setupView()
        setupCardsEvents()
    }
    
    private func setupView() {
        todayDateLabel.text = Date().asDayMonthString
    }
    
    private func setupCardsEvents() {
        
        let tap1 = UITapGestureRecognizer(target: self,
                                         action: #selector(showDashboard(sender:)))
        dashboardCard.isUserInteractionEnabled = true
        dashboardCard.addGestureRecognizer(tap1)
        
        
        let tap2 = UITapGestureRecognizer(target: self,
                                         action: #selector(showDashboard(sender:)))
        investCard.isUserInteractionEnabled = true
        investCard.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self,
                                          action: #selector(showDashboard(sender:)))
        helpdeskCard.isUserInteractionEnabled = true
        helpdeskCard.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self,
                                          action: #selector(showDashboard(sender:)))
        profileCard.isUserInteractionEnabled = true
        profileCard.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self,
                                          action: #selector(showDashboard(sender:)))
        settingsCard.isUserInteractionEnabled = true
        settingsCard.addGestureRecognizer(tap5)
    }
    
    @objc func showDashboard(sender: UIGestureRecognizer) {
        let vc = viewController(type: DashboardTabBarController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.selectedIndex = getIndexOfCard(sender: sender.view)
        LoginSession.shared.dashboardInformation = dashboardInformation
        present(vc, animated: true, completion: nil)
    }
    
    private func getIndexOfCard(sender: UIView?) -> Int {
        if sender == dashboardCard {
            return 0
        } else if sender == investCard {
            return 1
        } else if sender == helpdeskCard {
            return 2
        } else if sender == profileCard || sender == settingsCard {
            return 3
        }
        
        return 0
    }
}
