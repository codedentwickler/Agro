//
//  FundWalletViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 24/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Paystack
import FittedSheets

class FundWalletViewController: BaseViewController {

    public var cards: [CreditCard] = [CreditCard]()
    
    @IBOutlet weak var selectedCardBankNameLabel: UILabel!
    @IBOutlet weak var selectedCardTypeLabel: UILabel!
    @IBOutlet weak var selectedCardIconImageView: UIImageView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedCardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedCardView: UIView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var amountView: AmountInputView!
    @IBOutlet weak var useCardLabel: UILabel!
    
    private var selectedCard : CreditCard?
    private var fundWalletPresenter: FundWalletPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fundWalletPresenter = FundWalletPresenter(apiService: ApiServiceImplementation.shared,
                                                  view: self)
        
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        
        if cards.count == 0 {
            cardsCollectionView.isHidden = true
            selectedCardView.isHidden = true
            useCardLabel.isHidden = true
            selectedCardViewHeight.constant = 0;
            cardsCollectionViewHeight.constant = 0;
        }

        let profile = LoginSession.shared.dashboardInformation?.profile
        walletBalanceLabel.text = profile?.wallet?.walletBalance.commaSeparatedNairaValue
    }
    
    @IBAction func userPressedFundWallet(_ sender: Any) {
        let amount = amountView.amountInputTextField.getAmount(asMinor: false)
        AgroLogger.log("AMOUNT ENTERED \(amount)")
        
        if amount < 100 {
            showAlertDialog(title: "Amount to Small", message: "Minimum allowed amount is ₦100")
            return
        }
        
        if let selectedCard = selectedCard {
            fundWalletPresenter.fundWalletSavedCard(amount: amount, authCode: selectedCard.authorizationCode ?? "")
        } else {
            // Integrate new Card flow
            enterNewCardInformationModal()
        }
    }
    
    private func enterNewCardInformationModal() {
        let vc = PaymentViewController()
        vc.delegate = self
        
        let sheetController = SheetViewController(controller: vc,
                                                  sizes: [SheetSize.fixed(200)])
        sheetController.dismissOnBackgroundTap = true
        present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func userPressedManageCards(_ sender: Any) {
        let vc = viewController(type: ManageSavedCardsViewController.self,
                                from: StoryBoardIdentifiers.Wallet)
        vc.cards = cards
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCollectionView() {
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(UINib(nibName: CreditCardCollectionViewCell.identifier,
                                           bundle: nil),
                                     forCellWithReuseIdentifier: CreditCardCollectionViewCell.identifier)
        cardsCollectionView.allowsMultipleSelection = false
    }
}

extension FundWalletViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        selectedCardIconImageView.image = UIImage(named: imageBackgroundForCard(at: indexPath.row))
        selectedCardBankNameLabel.text = card.bank
        selectedCardTypeLabel.text = "\(card.cardType?.capitalizeFirstLetter() ?? "") \u{2022} \( card.last4 ?? "")"
        selectedCard = card
    }
}

extension FundWalletViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            CreditCardCollectionViewCell.identifier,
                                                      for: indexPath) as! CreditCardCollectionViewCell
        cell.cardbackgroud.image = UIImage(named: imageBackgroundForCard(at: indexPath.row))
        cell.card = cards[indexPath.row]
        return cell
    }
    
    private func imageBackgroundForCard(at rowNumber: Int) -> String {
        switch rowNumber % 3 {
        case 0:
            return "credit-card-bg-one"
        case 1:
            return "credit-card-bg-two"
        case 2:
            return "credit-card-bg-three"
        default:
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
}

extension FundWalletViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270 , height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}

extension FundWalletViewController: ProvideCardInformationDelegate {
    func userProvidedValidCardInfo(cardParams: PSTCKCardParams) {
        AgroLogger.log("CardParams \(cardParams)")
    }
}

extension FundWalletViewController: FundWalletView {
    func showFundYourWalletPage(cards: [CreditCard]) {}
    
    func walletFundingSuccessful(wallet: Wallet?) {
        let newBalance = (wallet?.walletBalance ?? 0).commaSeparatedNairaValue
        self.showAlertDialog(title: "Wallet Fund Successful",
                                   message: "Your wallet fund was successful. Your new wallet balance is \(newBalance)")
        self.walletBalanceLabel.text = newBalance
        LoginSession.shared.dashboardInformation?.profile?.wallet = wallet
    }
}

class PaymentViewController: UIViewController, PSTCKPaymentCardTextFieldDelegate {
    
    var delegate: ProvideCardInformationDelegate?
    let paymentTextField = PSTCKPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.white
        paymentTextField.frame = CGRect(x: 16, y: 16, width: self.view.frame.width , height: 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
    }
    
    func paymentCardTextFieldDidChange(_ textField: PSTCKPaymentCardTextField) {
        AgroLogger.log("IS CARD VALID ?? \(textField.isValid)")
        if textField.isValid {
            delegate?.userProvidedValidCardInfo(cardParams: textField.cardParams)
            sheetViewController?.dismiss(animated: true)
        }
    }
}

protocol ProvideCardInformationDelegate {
    func userProvidedValidCardInfo(cardParams: PSTCKCardParams)
}
