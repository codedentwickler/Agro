//
//  ReferralHistoryViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 19/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class ReferralHistoryViewController: BaseViewController {
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var redeemedReferralsTableView: UITableView!
    @IBOutlet weak var pendingReferralsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableViewDelegates()
    }

    @IBAction func pagerControlSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pendingReferralsTableView.isHidden = true
            redeemedReferralsTableView.isHidden = false
        } else {
            redeemedReferralsTableView.isHidden = true
            pendingReferralsTableView.isHidden = false
        }
    }
    
    private func setupTableViewDelegates() {
        redeemedReferralsTableView.delegate = self
        redeemedReferralsTableView.dataSource = self
        pendingReferralsTableView.delegate = self
        pendingReferralsTableView.dataSource = self
        redeemedReferralsTableView.reloadData()
        pendingReferralsTableView.reloadData()
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(userTapMenuButton))
        menuIconImageView.isUserInteractionEnabled = true
        menuIconImageView.addGestureRecognizer(tap)
        
        redeemedReferralsTableView.register(UINib(nibName: TransactionsTableViewCell.identifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: TransactionsTableViewCell.identifier)
        pendingReferralsTableView.register(UINib(nibName: TransactionsTableViewCell.identifier,
                                                  bundle: nil),
                                            forCellReuseIdentifier: TransactionsTableViewCell.identifier)
    }
    
    @objc private func userTapMenuButton() {
        
        let actions = [
            creatAlertAction("Sort by Date (Most recent)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Sort by Date (Least recent)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Sort by Amount (High to low)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Cancel", style: .cancel, clicked: { _ in
                
            })
        ]
        
        createActionSheet(ltrActions: actions)
    }
}

extension ReferralHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier)
            as! TransactionsTableViewCell
        
        if tableView == pendingReferralsTableView {
            cell.rootView.backgroundColor = UIColor(hex: "#F8F8F8", a: 0.08)
            cell.grayDotView.isHidden = false
            cell.iconImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
