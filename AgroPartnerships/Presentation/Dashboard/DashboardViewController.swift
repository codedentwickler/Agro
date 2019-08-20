//
//  DashboardViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 17/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    
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
    
    // Referral Outlets
    @IBOutlet weak var referralActionsCollectionView: UICollectionView!
    @IBOutlet weak var referralInputTextfield: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupDataSources()
        setupInvestmentsCollectionView()
        setupWalletCollectionView()
        setupReferralCollectionView()
        setupCurrentInvestmentsTableView()
        setupEventListeners()
        setupView()
    }
    
    private func setupView() {
        currentInvestmentsTableView.reloadData()
    }
    
    fileprivate func setupDataSources() {
        currentInvestmentsTableView.dataSource = self
        portfolioActionsCollectionView.dataSource = self
        walletsActionsCollectionView.dataSource = self
        referralActionsCollectionView.dataSource = self
    }
    
    fileprivate func setupDelegates() {
        currentInvestmentsTableView.delegate = self
        portfolioActionsCollectionView.delegate = self
        walletsActionsCollectionView.delegate = self
        referralActionsCollectionView.delegate = self
    }
    
    fileprivate func setupCurrentInvestmentsTableView(){
        currentInvestmentsTableView.register(UINib(nibName: CurrentInvestmentTableViewCell.identifier,
                                                      bundle: nil),
                                                forCellReuseIdentifier: CurrentInvestmentTableViewCell.identifier)
        
        currentInvestmentsTableViewHeight.constant =
            CGFloat(365 * 2)
        currentInvestmentsTableViewHeight.isActive = true
    }
    
    fileprivate func setupInvestmentsCollectionView(){
        portfolioActionsCollectionView.register(UINib(nibName: InvestmentCollectionViewCell.identifier,
                                                      bundle: nil),
                                                forCellWithReuseIdentifier: InvestmentCollectionViewCell.identifier)
        portfolioActionsCollectionView.allowsMultipleSelection = false
    }
    
    fileprivate func setupWalletCollectionView(){
        walletsActionsCollectionView.register(UINib(nibName: InvestmentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: InvestmentCollectionViewCell.identifier)
        walletsActionsCollectionView.allowsMultipleSelection = false
    }
    
    fileprivate func setupReferralCollectionView(){
        referralActionsCollectionView.register(UINib(nibName: InvestmentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: InvestmentCollectionViewCell.identifier)
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
        contentViewHeight.constant = 758.0 + (currentInvestmentsTableViewHeight.constant)
        contentViewHeight.isActive = true
    }
    
    private func showWalletTab() {
        hideAllTabs()
        ViewUtils.show(walletStackView)
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
    
    // Actions
    
    @objc private func userTapCheckPendingInvestmentIcon() {
        let vc = viewController(type: InvestmentsTableViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.isBeenUsedForPendingInvestments = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func userTapCloseIcon() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
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
        
    }

    // Referral Actions
    @IBAction func userPressedViewAllReferrals(_ sender: Any) {
        let vc = viewController(type: ReferralHistoryViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func userPresedCopyReferralCode(_ sender: Any) {
        
    }
    
    @IBAction func userPressedShareCode(_ sender: Any) {
        
    }
    
    // Porfolio Actions
    @IBAction func userPressedViewInvestmentHistory(_ sender: Any) {
        push(viewController: InvestmentsTableViewController.self,
             from: StoryBoardIdentifiers.Dashboard)
    }
}
