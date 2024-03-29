//
//  InvestDetailViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 27/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import FittedSheets
import Kingfisher
import ExpandableLabel

class InvestDetailViewController: BaseViewController {
    
    @IBOutlet weak var investmentImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var investButton: UIView!
    @IBOutlet weak var investActionButton: AgroActionButton!
    @IBOutlet weak var investButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var investButtonTopSpace: NSLayoutConstraint!
    @IBOutlet weak var investButtonBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var costPerUnitLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var unitLeftLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var investmentCodeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var otherCommoditiesCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    public var investment: Investment!
    public var investments: [Investment]!
    public var otherInvestments = [Investment]()
    
    private var investmentDetailPresenter: InvestmentDetailPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadImage()
        setupView()
        setupCollectionView()
        investmentDetailPresenter = InvestmentDetailPresenter(apiService: ApiServiceImplementation.shared,
                                                              view: self)
    }
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userPressedInvest(_:)))
        investButton.isUserInteractionEnabled = true
        investButton.addGestureRecognizer(tap)
        
        if investment.status != "available" {
            investButtonHeight.constant = CGFloat.zero
            investButtonTopSpace.constant = CGFloat.zero
            investButton.isHidden = true
            investActionButton.isHidden = true
        } else {
            investButton.isHidden = false
            investActionButton.isHidden = false
            investButtonHeight.constant =  CGFloat(50)
            investButtonTopSpace.constant = CGFloat(24)
        }
        
        typeLabel.text = investment.type?.uppercased()
        productNameLabel.text = investment.title
        costPerUnitLabel.text = investment.price?.commaSeparatedNairaValue
        yieldLabel.text = "\(investment.yield!)%"
        statusLabel.text = investment.status?.capitalized
        
        let unitLeft = investment.units ?? 0
        let unitsStr = unitLeft <= 1 ? "unit" : "units"
        unitLeftLabel.text = "\(unitLeft) \(unitsStr) left"
        
        let duration = investment.duration?.intValue ?? 0
        let durationStr = " \(duration) \(duration <= 1 ? "month" : "months")"
        durationLabel.text = durationStr
        
        investmentCodeLabel.text = investment.code
        locationLabel.text = investment.location
        
        let description = getDescription()
        
        descriptionLabel.numberOfLines = description.numberOfLines
        descriptionLabel.shouldCollapse = true
        descriptionLabel.collapsed = true
        descriptionLabel.textReplacementType = description.textReplacementType
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Read More")
        descriptionLabel.setLessLinkWith(lessLink: "Read Less", attributes: [.foregroundColor:UIColor.red], position: description.textAlignment)
        descriptionLabel.text = description.text
        descriptionLabel.delegate = self
        
        otherInvestments.removeAll()
        otherInvestments.append(contentsOf: investments)
        otherInvestments.removeAll(where: { $0.code == investment.code })
        otherCommoditiesCollectionView.reloadData()
        
    }
    
    func getDescription() -> (text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment) {
        return (investment.description ?? "", .word, 6, .left)
      }
    
    private func loadImage() {
        let url = URL(string: investment.picture!)
        let processor = DownsamplingImageProcessor(size: investmentImageView.frame.size)
        investmentImageView.kf.indicatorType = .activity
        investmentImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                self.investmentImageView.backgroundColor = UIColor.clear
                AgroLogger.log("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                AgroLogger.log("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupCollectionView() {
        otherCommoditiesCollectionView.delegate = self
        otherCommoditiesCollectionView.dataSource = self
        otherCommoditiesCollectionView.register(UINib(nibName: OtherCommoditiesCollectionViewCell.identifier,
                                                      bundle: nil),
                                                forCellWithReuseIdentifier: OtherCommoditiesCollectionViewCell.identifier)
        otherCommoditiesCollectionView.allowsMultipleSelection = false
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
        let modalVc = viewController(type: ProvideInvestmentDetailsModalStepOneViewController.self,
                                     from: StoryBoardIdentifiers.Invest)
        modalVc.investment = investment
        modalVc.delegate = self
        
        let controller = UINavigationController(rootViewController: modalVc)
        controller.isNavigationBarHidden = true
        let sheetController = SheetViewController(controller: controller,
                                                  sizes: [SheetSize.fixed(660.0), .fullScreen])
        sheetController.dismissOnBackgroundTap = false
        sheetController.blurBottomSafeArea = false
        sheetController.topCornersRadius = 0
        present(sheetController, animated: true, completion: nil)
    }
    //The dynamic stuff are the investment title (Sweet Potato), yield (35%), duration (7) and the code (ASADCE4851).
    //    And on live it'll be the live URL.
    @IBAction func userPressedShareCode(_ sender: Any) {
        let link = "https://staging.agropartnerships.co/investments/\(investment.code!)"
        let message = """
        Invest in Farms. Trade in Commodities. \(investment.title!) at \(investment.yield!)% yield for \(investment.duration!) months. \(link)
        """
        
        shareOnlyText(message)
    }
    
    @IBAction func userPressedReadMore(_ sender: Any) {
        let vc = viewController(type: InvestmentDescriptionViewController.self,
                                from: StoryBoardIdentifiers.Invest)
        vc.investment = investment
        navigationController?.pushViewController(vc, animated: true)
    }
 
    @objc func userPressedSeeAllOtherFarmCommodities(_ sender: Any) {
    }
}

extension InvestDetailViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension InvestDetailViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            OtherCommoditiesCollectionViewCell.identifier,
                                                      for: indexPath) as! OtherCommoditiesCollectionViewCell
        cell.investment = otherInvestments[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapViewInvestment(sender:)))
        cell.viewButton.isUserInteractionEnabled = true
        cell.viewButton.tag = indexPath.row
        cell.viewButton.addGestureRecognizer(tap)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherInvestments.count
    }
    
    @objc private func userTapViewInvestment(sender: UITapGestureRecognizer) {
        let row = sender.view!.tag
        self.investment = otherInvestments[row]
        setupView()
        scrollView.scrollToTop()
    }
}

extension InvestDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - (16 * 3))
        return CGSize(width: width , height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}

extension InvestDetailViewController: InvestmentDetailView {
    
    func showBankTransferView(investment: Investment) {
        let transferVc = viewController(type: BankTransferViewController.self, from: StoryBoardIdentifiers.Invest)
        transferVc.investment = investment
        navigationController?.pushViewController(transferVc, animated: true)
    }
    
    func showInvestmentSuccessfulDialog(units: Int, amountPaid: Int) {
        let message = "Your investment for \(units) units \(amountPaid.commaSeparatedNairaValue) was successful"
        
        let confirmAction = creatAlertAction("Confirm", style: .default, clicked: nil)

        createAlertDialog(title: "Investment Successful",
                          message: message,
                          ltrActions: [confirmAction])
    }
}

extension InvestDetailViewController: ProvideInvestmentDetailsDelegate {
    
    func userDidProvideInvestmentDetails(initializeTransactionRequest: InitializeInvestmentRequest) {
        
        if initializeTransactionRequest.units == 0 {
            showAlertDialog(title: "Unit too small", message: "Minimum number of unit you can purchase is 1")
            return
        }
        
        if initializeTransactionRequest.paymentMethod == .wallet {
            investmentDetailPresenter.initializeInvestment(initializeTransactionRequest)
        } else if initializeTransactionRequest.paymentMethod == .transfer {
            investmentDetailPresenter.initializeInvestment(initializeTransactionRequest)
        } else {
            let payVc = viewController(type: PayInvestmentViewController.self, from: StoryBoardIdentifiers.Invest)
            payVc.initializeTransactionRequest = initializeTransactionRequest
            navigationController?.pushViewController(payVc, animated: true)
        }
    }
}

extension InvestDetailViewController: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {}
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let textHeight = label.intrinsicContentSize.height
        contentViewHeight.constant = CGFloat(1550) + textHeight
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {}
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let textHeight = label.intrinsicContentSize.height
        contentViewHeight.constant = CGFloat(1550)
    }
}
