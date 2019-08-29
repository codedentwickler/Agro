//
//  InvestDetailViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 27/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import FittedSheets

class InvestDetailViewController: UIViewController {
    
    @IBOutlet weak var investButton: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var costPerUnitLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var unitLeftLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var investmentCodeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var investmentDescriptionTextView: UITextView!
    @IBOutlet weak var otherCommoditiesCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    public var investment: Investment!
    public var investments: [Investment]!
    public var otherInvestments = [Investment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        typeLabel.text = investment.type?.capitalizeFirstLetter()
        productNameLabel.text = investment.title
        costPerUnitLabel.text = investment.price?.commaSeparatedValue
        yieldLabel.text = "\(investment.yield!)%"
        statusLabel.text = investment.status?.capitalizeFirstLetter()
        let unitLeft = investment.units ?? 0
        let unitsStr = unitLeft <= 1 ? "unit" : "units"
        unitLeftLabel.text = "\(unitLeft) \(unitsStr) left"
        let duration = investment.duration?.intValue ?? 0
        let durationStr = " \(duration) \(duration <= 1 ? "month" : "months")"
        durationLabel.text = durationStr
        investmentCodeLabel.text = investment.code
        locationLabel.text = investment.location
        investmentDescriptionTextView.text = investment.description
        
        otherCommoditiesCollectionView.delegate = self
        otherCommoditiesCollectionView.dataSource = self
        otherCommoditiesCollectionView.register(UINib(nibName: OtherCommoditiesCollectionViewCell.identifier,
                                                          bundle: nil),
                                                    forCellWithReuseIdentifier: OtherCommoditiesCollectionViewCell.identifier)
        otherCommoditiesCollectionView.allowsMultipleSelection = false
        
        otherInvestments.removeAll()
        otherInvestments.append(contentsOf: investments)
        otherInvestments.removeAll(where: { $0.code == investment.code })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.makeNavigationBarTransparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.returnNavigationBarToDefault()
    }
    
    @IBAction func userPressedInvest(_ sender: Any) {
        let modalVc = viewController(type: ProvideInvestmentDetailsModalViewController.self,
                                     from: StoryBoardIdentifiers.Invest)
        let controller = UINavigationController(rootViewController: modalVc)
        controller.isNavigationBarHidden = true
        let sheetController = SheetViewController(controller: controller,
                                                  sizes: [SheetSize.fixed(570.0)])
        sheetController.dismissOnBackgroundTap = false
        sheetController.blurBottomSafeArea = false
        sheetController.topCornersRadius = 0
        present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func userPressedShareCode(_ sender: Any) {
    }
    
    @IBAction func userPressedReadMore(_ sender: Any) {
    }
 
    @objc func userPressedSeeAllOtherFarmCommodities(_ sender: Any) {

    }
}

extension InvestDetailViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // refresh entire view and replace current investment
    }
}

extension InvestDetailViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            OtherCommoditiesCollectionViewCell.identifier,
                                                      for: indexPath) as! OtherCommoditiesCollectionViewCell
        cell.investment = otherInvestments[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherInvestments.count
    }
}

extension InvestDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335 , height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
