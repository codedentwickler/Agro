//
//  ProvideInvestmentDetailsModalStepTwoViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 29/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Kingfisher

class ProvideInvestmentDetailsModalStepTwoViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalAmountLabel: UILabel!
    @IBOutlet weak var walletFundsLabel: UILabel!
    @IBOutlet weak var walletFundsAmountLabel: UILabel!
    @IBOutlet weak var paymentLeftLabel: UILabel!
    @IBOutlet weak var paymentLeftAmountLabel: UILabel!
    @IBOutlet weak var paymentMethodCollectionView: UICollectionView!
    @IBOutlet weak var paymentCollectionViewHeight: NSLayoutConstraint!
    
    var delegate: ProvideInvestmentDetailsDelegate?
    var investment: Investment!
    var totalUnitSelected: Int!
    
    private var amountLeftToPayAfterWalletDeduction = 0
    private var walletDeductionAmount = 0
    private var walletBalance = 0
    private var selectedPaymentMethod: PaymentMethod = .none

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        loadImage()
    }
    
    private func loadImage() {
        let url = URL(string: investment.picture!)
        let processor = DownsamplingImageProcessor(size: iconImageView.frame.size) >> RoundCornerImageProcessor(cornerRadius: 10)

        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ]){
            result in
            switch result {
            case .success(let value):
                AgroLogger.log("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                AgroLogger.log("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupView() {
        paymentMethodCollectionView.delegate = self
        paymentMethodCollectionView.dataSource = self
        paymentMethodCollectionView.allowsMultipleSelection = false
        paymentMethodCollectionView.reloadData()
        
        productNameLabel.text = investment.title
        descriptionLabel.text = """
        \(investment.price!.commaSeparatedNairaValue)/unit
        \(investment.yield!)% in \(investment.duration!) months
        """
        
        subTotalLabel.text = "Sub total (\(totalUnitSelected.string) \(totalUnitSelected <= 1 ? "unit" : "units"))"
        let totalCost = totalUnitSelected * (investment.price ?? 0)
        subTotalAmountLabel.text = totalCost.commaSeparatedNairaValue
        
        let profile = LoginSession.shared.dashboardInformation?.profile
        let withdrawable = profile?.wallet?.funds ?? 0
        let nonWithdrawable = profile?.wallet?.bonus?.balance ?? 0
        walletBalance = withdrawable + nonWithdrawable
        
//        walletFundsLabel.text = "Wallet Funds (\(walletBalance.commaSeparatedNairaValue))"
        walletFundsAmountLabel.text = "- \(walletBalance.commaSeparatedNairaValue)"
        
        if totalCost <= walletBalance {
            amountLeftToPayAfterWalletDeduction = 0
            walletDeductionAmount = totalCost
        } else {
            amountLeftToPayAfterWalletDeduction = totalCost - walletBalance
            walletDeductionAmount = walletBalance
        }
        
        if amountLeftToPayAfterWalletDeduction == 0 {
            paymentMethodCollectionView.isHidden = true
            paymentCollectionViewHeight.constant = CGFloat(0)
        }
        
        paymentLeftAmountLabel.text = amountLeftToPayAfterWalletDeduction.commaSeparatedNairaValue
        
    }
    
    @IBAction func userPressedCancel(_ sender: Any) {
        sheetViewController?.dismiss(animated: true)
    }
    
    @IBAction func userPressedPrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userPressedInvest(_ sender: Any) {
        
        if amountLeftToPayAfterWalletDeduction == 0 {
            // Create investment
            selectedPaymentMethod = .wallet
        }
        let request = InitializeInvestmentRequest(item: investment.code!,
                                                  units: totalUnitSelected,
                                                  price: investment.price!,
                                                  credit: walletBalance,
                                                  amountLeft: amountLeftToPayAfterWalletDeduction,
                                                  paymentMethod: selectedPaymentMethod,
                                                  authCode: nil)
        sheetViewController?.dismiss(animated: true)
        delegate?.userDidProvideInvestmentDetails(initializeTransactionRequest: request)
    }
}

extension ProvideInvestmentDetailsModalStepTwoViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentMethod = indexPath.row == 0 ? PaymentMethod.card : PaymentMethod.transfer
    }
}

extension ProvideInvestmentDetailsModalStepTwoViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            PaymentMethodCollectionViewCell.identifier,
                                                      for: indexPath) as! PaymentMethodCollectionViewCell
        cell.paymentMethodLabel.text = indexPath.row == 0 ? "Credit/Debit card" : "Bank Transfer"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
}

extension ProvideInvestmentDetailsModalStepTwoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220 , height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

class PaymentMethodCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var selectedIndicatorImageView: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelected()
            } else {
                setDeselected()
            }
        }
    }
    
    fileprivate func setDeselected() {
        UIView.animate(withDuration: 0.25) {
            self.selectedIndicatorImageView.image = UIImage(named: "payment_method_deselected_icon")
        }
    }
    
    fileprivate func setSelected() {
        UIView.animate(withDuration: 0.25) {
            self.selectedIndicatorImageView.image = UIImage(named: "payment_method_selected_icon")
        }
    }
}

protocol ProvideInvestmentDetailsDelegate {
    func userDidProvideInvestmentDetails(initializeTransactionRequest: InitializeInvestmentRequest)
}
