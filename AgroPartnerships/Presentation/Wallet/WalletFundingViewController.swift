//
//  WalletFundingViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 23/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class WalletFundingViewController: BaseViewController {
    
    public var transactions: [Transactions]!
    
    private var fundingTransactions: [Transactions] = [Transactions]()
    private var payoutsTransactions: [Transactions] = [Transactions]()

    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var fundingHistoryTableView: UITableView!
    @IBOutlet weak var payoutsHistoryTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var actionButton: AgroActionButton!
    @IBOutlet weak var pagerControl: UISegmentedControl!
    
    private var currentTableView: UITableView!
    
    private var fundWalletPresenter: FundWalletPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fundWalletPresenter = FundWalletPresenter(apiService: ApiServiceImplementation.shared,
                                                  view: self)
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
        currentTableView = fundingHistoryTableView
        fundingHistoryTableView.isHidden = false
        payoutsHistoryTableView.isHidden = true
        headerLabel.text = """
        All payments made directly (as card/online/cash transfers from the farm & commodity page or as reinvestments from a complete investment) would not show up here. Please check “All Transactions”  for direct payments. Only payments made into the wallet would show up here.
        """
        
        actionButton.setTitle("Fund Wallet", for: .normal)
    }
    
    private func updateOnPayoutsPressed() {
        currentTableView = payoutsHistoryTableView
        fundingHistoryTableView.isHidden = true
        payoutsHistoryTableView.isHidden = false
        headerLabel.text = """
        All debit payments made directly (as card/online/cash transfers from the farm & commodity page or as reinvestments) would not show up here. Please check “All Transactions” for direct debit payments. Only payments from your wallet to your registered bank account would show up here.
        """
        actionButton.setTitle("Request Payout", for: .normal)
    }
    
    @IBAction func userPressedActionButton(_ sender: Any) {
        
        if pagerControl.selectedSegmentIndex == 0 {
            fundWalletPresenter.getAllCards()
        } else {
            pushRequestPayoutController()
        }
    }
    
    private func pushFundWalletController(cards: [CreditCard]) {
        let vc  = viewController(type: FundWalletViewController.self,
                                 from: StoryBoardIdentifiers.Wallet)
        vc.cards = cards
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
        
        for transaction in transactions {
            if transaction.category == ApiConstants.Payout {
                payoutsTransactions.append(transaction)
            } else if transaction.category == ApiConstants.FundWallet {
                fundingTransactions.append(transaction)
            }
        }
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
        return tableView == fundingHistoryTableView ? fundingTransactions.count : payoutsTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier)
            as! TransactionsTableViewCell
        
        if tableView == payoutsHistoryTableView {
            cell.transaction = payoutsTransactions[indexPath.row]
        } else {
            cell.transaction = fundingTransactions[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension WalletFundingViewController: FundWalletView {
    func walletFundingSuccessful(wallet: Wallet?) {}
    
    func showFundYourWalletPage(cards: [CreditCard]) {
        pushFundWalletController(cards: cards)
    }
}
