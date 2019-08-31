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

    private var currentTableView: UITableView!

    var referrals : [Referral]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableViewDelegates()
    }

    @IBAction func pagerControlSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pendingReferralsTableView.isHidden = true
            redeemedReferralsTableView.isHidden = false
            currentTableView = redeemedReferralsTableView
        } else {
            redeemedReferralsTableView.isHidden = true
            pendingReferralsTableView.isHidden = false
            currentTableView = pendingReferralsTableView
        }
    }
    
    private func setupTableViewDelegates() {
        redeemedReferralsTableView.delegate = self
        redeemedReferralsTableView.dataSource = self
        pendingReferralsTableView.delegate = self
        pendingReferralsTableView.dataSource = self
        redeemedReferralsTableView.reloadData()
        pendingReferralsTableView.reloadData()
        currentTableView = redeemedReferralsTableView
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(userTapMenuButton))
        menuIconImageView.isUserInteractionEnabled = true
        menuIconImageView.addGestureRecognizer(tap)
        
        redeemedReferralsTableView.register(UINib(nibName: ReferralsTableViewCell.identifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: ReferralsTableViewCell.identifier)
        pendingReferralsTableView.register(UINib(nibName: ReferralsTableViewCell.identifier,
                                                  bundle: nil),
                                            forCellReuseIdentifier: ReferralsTableViewCell.identifier)
    }
    
    @objc private func userTapMenuButton() {
        var sortedReferrals = [Referral]()

        let actions = [
            creatAlertAction("Sort by Date (Most recent)", style: .default, clicked: { _ in
                sortedReferrals = self.referrals.sorted(by: {$0.date!.dateFromFullString!.compare($1.date!.dateFromFullString!)
                    == .orderedDescending })
                self.referrals = sortedReferrals
                self.currentTableView.reloadData()
            }),
            creatAlertAction("Sort by Date (Least recent)", style: .default, clicked: { _ in
                sortedReferrals = self.referrals.sorted(by: {$0.date!.dateFromFullString!.compare($1.date!.dateFromFullString!)
                    == .orderedAscending })
                self.referrals = sortedReferrals
                self.currentTableView.reloadData()
            }),
            creatAlertAction("Sort by Amount (High to low)", style: .default, clicked: { _ in
                sortedReferrals = self.referrals.sorted(by: {$0.amount! > $1.amount!})
                self.referrals = sortedReferrals
                self.currentTableView.reloadData()
            }),
            creatAlertAction("Cancel", style: .cancel, clicked: nil)
        ]
        
        createActionSheet(ltrActions: actions)
    }
}

extension ReferralHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referrals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReferralsTableViewCell.identifier)
            as! ReferralsTableViewCell
        
        if tableView == pendingReferralsTableView {
            cell.rootView.backgroundColor = UIColor(hex: "#F8F8F8", a: 0.08)
            cell.grayDotView.isHidden = false
            cell.iconImageView.isHidden = true
        }
        
        let referral = referrals[indexPath.row]
        
        cell.dateLabel.text = referral.date?.asFullDate(format: "E - d MMM, yyyy")
        cell.amountLabel.text = referral.amount?.commaSeparatedNairaValue
        cell.descriptionLabel.text = "Referral Bonus \(referral.userFullName ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

typealias ReferralsTableViewCell = TransactionsTableViewCell
