//
//  WalletFundingViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 23/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class WalletFundingViewController: BaseViewController {
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var fundingHistoryTableView: UITableView!
    @IBOutlet weak var payoutsHistoryTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var actionButton: AgroActionButton!
    @IBOutlet weak var pagerControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableViewDelegates()
    }
    
    @IBAction func pagerControlSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            updateOnFundingPressed()
        } else {
            updateOnPayoutsPressed()
        }
    }
    
    private func updateOnFundingPressed() {
        fundingHistoryTableView.isHidden = false
        payoutsHistoryTableView.isHidden = true
        headerLabel.text = """
        All payments made directly (as card/online/cash transfers from the farm & commodity page or as reinvestments from a complete investment) would not show up here. Please check “All Transactions”  for direct payments. Only payments made into the wallet would show up here.
        """
        actionButton.titleLabel?.text = "Fund Wallet"
    }
    
    private func updateOnPayoutsPressed() {
        fundingHistoryTableView.isHidden = true
        payoutsHistoryTableView.isHidden = false
        headerLabel.text = """
        All debit payments made directly (as card/online/cash transfers from the farm & commodity page or as reinvestments) would not show up here. Please check “All Transactions” for direct debit payments. Only payments from your wallet to your registered bank account would show up here.
        """
        actionButton.titleLabel?.text = "Request Payout"
    }
    
    @IBAction func userPressedActionButton(_ sender: Any) {
        
        if pagerControl.selectedSegmentIndex == 0 {
            pushFundWalletController()
        } else {
            pushRequestPayoutController()
        }
    }
    
    private func pushFundWalletController() {
        
        let vc  = viewController(type: FundWalletViewController.self,
                                 from: StoryBoardIdentifiers.Wallet)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushRequestPayoutController() {
        let vc  = viewController(type: RequestPayoutViewController.self,
                                 from: StoryBoardIdentifiers.Wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableViewDelegates() {
        fundingHistoryTableView.delegate = self
        fundingHistoryTableView.dataSource = self
        payoutsHistoryTableView.delegate = self
        payoutsHistoryTableView.dataSource = self
        fundingHistoryTableView.reloadData()
        payoutsHistoryTableView.reloadData()
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(userTapMenuButton))
        menuIconImageView.isUserInteractionEnabled = true
        menuIconImageView.addGestureRecognizer(tap)
        
        fundingHistoryTableView.register(UINib(nibName: TransactionsTableViewCell.identifier,
                                                  bundle: nil),
                                            forCellReuseIdentifier: TransactionsTableViewCell.identifier)
        payoutsHistoryTableView.register(UINib(nibName: TransactionsTableViewCell.identifier,
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


extension WalletFundingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier)
            as! TransactionsTableViewCell
        
        if tableView == payoutsHistoryTableView {
            cell.rootView.backgroundColor = UIColor(hex: "#F8F8F8", a: 0.08)
            cell.iconImageView.image = UIImage(named: "red-arrow-down")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
