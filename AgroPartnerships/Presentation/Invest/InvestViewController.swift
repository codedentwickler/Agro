//
//  InvestViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class InvestViewController: BaseViewController {

    public var availableinvestments : [Investment] = []
    public var soldInvestments : [Investment] = []

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet weak var availableInvestmentsCollectionView: UICollectionView!
    @IBOutlet weak var soldOutInvestmentsTableView: UITableView!
    @IBOutlet weak var soldOutInvestmentsTableViewHeight: NSLayoutConstraint!
    
    private var presenter: InvestPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupEventListeners()
        presenter = InvestPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
        presenter?.getInvestmentsInformation()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupView() {
        availableInvestmentsCollectionView.delegate = self
        availableInvestmentsCollectionView.dataSource = self
        soldOutInvestmentsTableView.delegate = self
        soldOutInvestmentsTableView.dataSource = self
        
        soldOutInvestmentsTableView.register(UINib(nibName: SoldOutInvestmentTableViewCell.identifier,
                                                   bundle: nil), forCellReuseIdentifier: SoldOutInvestmentTableViewCell.identifier)
        availableInvestmentsCollectionView.register(UINib(nibName: AvailableInvestmentCollectionViewCell.identifier,
                                           bundle: nil),
                                     forCellWithReuseIdentifier: AvailableInvestmentCollectionViewCell.identifier)
        availableInvestmentsCollectionView.allowsMultipleSelection = false
    }
    
    private func updateSizeOfViews() {
        
    }

    private func setupEventListeners() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapCloseIcon))
        closeIconImageView.isUserInteractionEnabled = true
        closeIconImageView.addGestureRecognizer(tap)
    }
    
    @IBAction func userPressedSeeAllAvailableInvestments(_ sender: Any) {
        let vc = viewController(type: AvailableInvestmentViewController.self,
                                from: StoryBoardIdentifiers.Invest)
        vc.investments = availableinvestments
        vc.isBeenUsedForSoldOutInvestments = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func userPressedSeeAllSoldOutInvestments(_ sender: Any) {
        let vc = viewController(type: AvailableInvestmentViewController.self,
                                from: StoryBoardIdentifiers.Invest)
        vc.investments = soldInvestments
        vc.isBeenUsedForSoldOutInvestments = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension InvestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3, soldInvestments.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SoldOutInvestmentTableViewCell.identifier)
            as! SoldOutInvestmentTableViewCell
        cell.investment = soldInvestments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

extension InvestViewController : InvestView {
    
    func showInvestmentsInformation(viewModel: InvestViewModel) {
        
        self.availableinvestments = viewModel.availableInvestments
        self.soldInvestments = viewModel.soldInvestments
        
        soldOutInvestmentsTableView.reloadData()
        availableInvestmentsCollectionView.reloadData()
        soldOutInvestmentsTableViewHeight.constant = CGFloat( 120 *  min(3, soldInvestments.count))
        
        contentViewHeight.constant = 1150.0 + (soldOutInvestmentsTableViewHeight.constant)
        contentViewHeight.isActive = true
        
        if soldInvestments.count == 0 {
            soldOutInvestmentsTableView.setEmptyMessage("No sold out investment")
        }
    }
}

extension InvestViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension InvestViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AvailableInvestmentCollectionViewCell.identifier,
            for: indexPath) as! AvailableInvestmentCollectionViewCell
        
        cell.investment = availableinvestments[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapViewInvestment(sender:)))
        cell.viewButton.isUserInteractionEnabled = true
        cell.viewButton.tag = indexPath.row
        cell.viewButton.addGestureRecognizer(tap)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableinvestments.count
    }
    
    @objc private func userTapViewInvestment(sender: UITapGestureRecognizer) {
        let row = sender.view!.tag
        let vc = viewController(type: InvestDetailViewController.self, from: StoryBoardIdentifiers.Invest)
        vc.investments = self.availableinvestments
        vc.investment = self.availableinvestments[row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension InvestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - (16 * 3))
        return CGSize(width: width , height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
