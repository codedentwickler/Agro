//
//  DashboardViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 17/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON

class DashboardViewController: BaseViewController {
    
    internal var dashboardInformation: DashboardResponse!
    internal var currentInvestments: [Portfolio] = [Portfolio]()
    internal var investmentHistory: [Portfolio] = [Portfolio]()
    internal var pendingInvestments: [Portfolio] = [Portfolio]()

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UISegmentedControl!
    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet weak var walletStackView: UIStackView!
    @IBOutlet weak var portfolioStackView: UIStackView!
    @IBOutlet weak var referralStackView: UIStackView!
    
    // Portfolio Outlets
    @IBOutlet weak var portfolioActionsCollectionView: UICollectionView!
    @IBOutlet weak var checkPendingInvestmentButton: UIView!
    @IBOutlet weak var currentInvestmentsTableView: UITableView!
    @IBOutlet weak var currentInvestmentsTableViewHeight: NSLayoutConstraint!

    // Wallets Outlets
    @IBOutlet weak var walletsActionsCollectionView: UICollectionView!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var transactionsTableViewHeight: NSLayoutConstraint!

    // Referral Outlets
    @IBOutlet weak var referralActionsCollectionView: UICollectionView!
    @IBOutlet weak var referralInputTextfield: UITextField!
    @IBOutlet weak var viewWalletAccountButton: AgroActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupDataSources()
        setupInvestmentsCollectionView()
        setupTransactionsTableView()
        setupWalletCollectionView()
        setupReferralCollectionView()
        setupCurrentInvestmentsTableView()
        setupEventListeners()
        showPortfolioTab()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setup() {
        setupView()
        updateSizeOfViews()
        updateWalletAccountView()
    }
    
    private func updateSizeOfViews() {
        transactionsTableViewHeight.constant = CGFloat(max(128 * (dashboardInformation.transactions?.count ?? 0) , 20 ))
        transactionsTableViewHeight.isActive = true

        currentInvestmentsTableViewHeight.constant =
            CGFloat(max(320 * (currentInvestments.count), 20) )
        currentInvestmentsTableViewHeight.isActive = true
    }

    private func setupView() {
        AgroLogger.log("setupView was called")
        currentInvestments.removeAll()
        pendingInvestments.removeAll()
        investmentHistory.removeAll()

        dashboardInformation = LoginSession.shared.dashboardInformation
        
        for investment in dashboardInformation.portfolio! {
            if investment.status == ApiConstants.Active {
                currentInvestments.append(investment)
            } else if investment.status == ApiConstants.Pending {
                pendingInvestments.append(investment)
            } else {
                investmentHistory.append(investment)
            }
        }
        
        referralInputTextfield.text = dashboardInformation.profile?.refCode
        
        if currentInvestments.count == 0 {
            currentInvestmentsTableView.setEmptyMessage("No current investment")
        }
        
        if (dashboardInformation.transactions?.count ?? 0) == 0 {
            transactionsTableView.setEmptyMessage("No investment history")
        }
        userChangedPagerValue(pageControl)
        currentInvestmentsTableView.reloadData()
        transactionsTableView.reloadData()
    }
    
    private func updateWalletAccountView() {
        
        if dashboardInformation.walletBankAccount == nil {
            viewWalletAccountButton.setTitle("Generate Account Number",
                                             for: .normal)
        } else {
            viewWalletAccountButton.setTitle("View Wallet Account",
                                             for: .normal)
        }
    }
    
    private func setupDataSources() {
        currentInvestmentsTableView.dataSource = self
        transactionsTableView.dataSource = self
        portfolioActionsCollectionView.dataSource = self
        walletsActionsCollectionView.dataSource = self
        referralActionsCollectionView.dataSource = self
    }
    
    private func setupDelegates() {
        currentInvestmentsTableView.delegate = self
        transactionsTableView.delegate = self
        portfolioActionsCollectionView.delegate = self
        walletsActionsCollectionView.delegate = self
        referralActionsCollectionView.delegate = self
    }
    
    private func setupTransactionsTableView(){
        transactionsTableView.register(UINib(nibName: TransactionsTableViewCell.identifier, bundle: nil),
                                       forCellReuseIdentifier: TransactionsTableViewCell.identifier)
    }
    
    private func setupCurrentInvestmentsTableView(){
        currentInvestmentsTableView.register(UINib(nibName: CurrentInvestmentTableViewCell.identifier,
                                                   bundle: nil),
                                             forCellReuseIdentifier: CurrentInvestmentTableViewCell.identifier)
    }
    
    private func setupInvestmentsCollectionView(){
        portfolioActionsCollectionView.register(UINib(nibName: DashboardActionCollectionViewCell.identifier,
                                                      bundle: nil),
                                                forCellWithReuseIdentifier: DashboardActionCollectionViewCell.identifier)
        portfolioActionsCollectionView.allowsMultipleSelection = false
    }
    
    private func setupWalletCollectionView(){
        walletsActionsCollectionView.register(UINib(nibName: DashboardActionThreeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DashboardActionThreeCollectionViewCell.identifier)
        walletsActionsCollectionView.allowsMultipleSelection = false
    }
    
    private func setupReferralCollectionView(){
        referralActionsCollectionView.register(UINib(nibName: DashboardActionThreeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DashboardActionThreeCollectionViewCell.identifier)
        referralActionsCollectionView.allowsMultipleSelection = false
    }
    
    private func setupEventListeners() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapCloseIcon))
        closeIconImageView.isUserInteractionEnabled = true
        closeIconImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(userTapCheckPendingInvestmentIcon))
        checkPendingInvestmentButton.isUserInteractionEnabled = true
        checkPendingInvestmentButton.addGestureRecognizer(tap2)
    }
    
    private func showPortfolioTab() {
        hideAllTabs()
        ViewUtils.show(portfolioStackView)
        contentViewHeight.constant = 780.0 + (currentInvestmentsTableViewHeight.constant)
        contentViewHeight.isActive = true
    }
    
    private func showWalletTab() {
        hideAllTabs()
        ViewUtils.show(walletStackView)
        contentViewHeight.constant = 780.0 + (transactionsTableViewHeight.constant)
        contentViewHeight.isActive = true
    }
    
    private func showReferralTab() {
        hideAllTabs()
        ViewUtils.show(referralStackView)
        contentViewHeight.constant = 1200.0
        contentViewHeight.isActive = true
    }
    
    private func hideAllTabs() {
        ViewUtils.hide(portfolioStackView, walletStackView , referralStackView)
    }
    
    private func loadCards() {
        ApiServiceImplementation.shared.getAllCards { (cardResponse) in
            guard let response = cardResponse else { return }
            
            if let cards = response.cards {
                LoginSession.shared.cards = cards
            }
        }
    }

    // Actions
    
    @objc private func userTapCheckPendingInvestmentIcon() {
        let vc = viewController(type: InvestmentsTableViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.isBeenUsedForPendingInvestments = true
        vc.investments = pendingInvestments
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func userChangedPagerValue(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            showPortfolioTab()
        case 1:
            showWalletTab()
        case 2:
            showReferralTab()
        default:
            break
        }
    }
    
    // Wallets Actions
    @IBAction func userPressedViewAllBreakdown(_ sender: Any) {
        let vc = viewController(type: WalletFundingViewController.self,
                                from: StoryBoardIdentifiers.Wallet)
        vc.transactions = dashboardInformation.transactions
        navigationController?.pushViewController(vc, animated: true)
    }

    // Referral Actions
    @IBAction func userPressedViewAllReferrals(_ sender: Any) {
        let vc = viewController(type: ReferralHistoryViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.referrals = dashboardInformation.referrals
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func userPresedCopyReferralCode(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = dashboardInformation.profile?.refCode
        showToast(withMessage: "Referral Code Copied")
    }
    
    @IBAction func userPressedViewWalletAccount(_ sender: Any) {
        if let walletAccount = dashboardInformation.walletBankAccount {
            let title = "Wallet Account Details"
            let message = "Account Number: \(walletAccount.accountNumber ?? "NA")\nAccount Name: \(walletAccount.accountName ?? "NA")\nBank Name: \(walletAccount.bankName ?? "NA")"
            
            showAlertDialog(title: title, message: message)
        } else {
            generateReservedAccount()
        }
    }
    
    @IBAction func userPressedShareCode(_ sender: Any) {
        let refCode = dashboardInformation.profile?.refCode ?? ""
        let message = "Use My referral code, \(refCode) https://agropartnerships.co/sign-up?ref=\(refCode)"
        shareOnlyText(message)
    }
    
    // Porfolio Actions
    @IBAction func userPressedViewInvestmentHistory(_ sender: Any) {
        let vc = viewController(type: InvestmentsTableViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.isBeenUsedForPendingInvestments = false
        vc.investments = investmentHistory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func generateReservedAccount() {
        
        showLoading(withMessage: "Generating Reserved Account . . .")
        ApiServiceImplementation.shared.generateReservedAccount { (response) in
            self.dismissLoading()
            
            guard let walletAccount = response else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if walletAccount.status == ApiConstants.Success {
                //Update current login session values.
                LoginSession.shared.dashboardInformation?.walletBankAccount = walletAccount
                self.dashboardInformation = LoginSession.shared.dashboardInformation
                self.updateWalletAccountView()
            } else {
                self.showAlertDialog(message: "An unexpected error occured while trying reserve your account.")
            }
        }
    }
}
