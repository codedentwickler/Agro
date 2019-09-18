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

    private var cards: [CreditCard]!
    
    @IBOutlet weak var selectedCardBankNameLabel: UILabel!
    @IBOutlet weak var selectedCardTypeLabel: UILabel!
    @IBOutlet weak var selectedCardIconImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedCardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedCardView: UIView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var amountView: AmountInputView!
    @IBOutlet weak var useCardLabel: UILabel!
    
    private var selectedCard : CreditCard? = nil {
        didSet {
            if let selectedCard = selectedCard {
                switch selectedCard.cardType?.trim() {
                case "visa":
                    selectedCardIconImageView.image = UIImage.pstck_visaCard()
                case "mastercard":
                    selectedCardIconImageView.image = UIImage.pstck_masterCardCard()
                case "verve":
                    selectedCardIconImageView.image = UIImage.pstck_brandImage(for: .verve)
                default:
                    selectedCardIconImageView.image = UIImage.pstck_unknownCardCard()
                }
                selectedCardTypeLabel.text = "\(selectedCard.cardType?.capitalizeFirstLetter() ?? "") \u{2022} \( selectedCard.last4 ?? "")"
                selectedCardBankNameLabel.text = selectedCard.bank
                selectedCardView.isHidden = false
                useCardLabel.isHidden = false
                selectedCardViewHeight.constant = 76
                cardView.isHidden = false
            } else {
                hideSelectedCardView()
            }
        }
    }
        
    private var fundWalletPresenter: FundWalletPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        fundWalletPresenter = FundWalletPresenter(apiService: ApiServiceImplementation.shared,
                                                  view: self)
        hideSelectedCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    private func setupView() {
        
        cards = LoginSession.shared.cards
        
        if cards.count == 0 {
            cardsCollectionView.isHidden = true
            selectedCardView.isHidden = true
            useCardLabel.isHidden = true
            selectedCardViewHeight.constant = 0;
            cardsCollectionViewHeight.constant = 0;
            hideSelectedCardView()
        }

        let profile = LoginSession.shared.dashboardInformation?.profile
        walletBalanceLabel.text = profile?.wallet?.walletBalance.commaSeparatedNairaValue
    }
    
    private func hideSelectedCardView() {
        selectedCardIconImageView.image = UIImage.pstck_unknownCardCard()
        selectedCardTypeLabel.text = nil
        selectedCardBankNameLabel.text = nil
        selectedCardView.isHidden = true
        useCardLabel.isHidden = true
        selectedCardViewHeight.constant = 0
        cardView.isHidden = true
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
        vc.cards = LoginSession.shared.cards
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCollectionView() {
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(UINib(nibName: CreditCardCollectionViewCell.identifier,
                                           bundle: nil),
                                     forCellWithReuseIdentifier: CreditCardCollectionViewCell.identifier)
        cardsCollectionView.allowsMultipleSelection = true
    }
}

extension FundWalletViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCard = nil
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
        
        return 20.0
    }
}

extension FundWalletViewController: ProvideCardInformationDelegate {
    func userProvidedValidCardInfo(cardParams: PSTCKCardParams) {
        let amount = amountView.amountInputTextField.getAmount(asMinor: false)
        AgroLogger.log("CardParams \(cardParams)")
        fundWalletPresenter.chargeCardWithPaystack(amount: amount.intValue, cardParams: cardParams, self)
    }
}

extension FundWalletViewController: FundWalletView {
    
    func showCardAddedDialog() {
        
        self.createAlertDialog(title: "Card Added Successfully",
                               message: "You can now use this card to pay in the future",
                               ltrActions: [creatAlertAction("Ok",style: .default, clicked: { _ in
                                self.gotoDashboard()
                               })])
    }
    
    func walletFundingSuccessful(wallet: Wallet?, authorization: Authorization?) {
        let newBalance = (wallet?.walletBalance ?? 0).commaSeparatedNairaValue
        
        let confirmAction = creatAlertAction("Confirm", style: .default, clicked: { _ in
            if authorization != nil && authorization?.reusable == true {
                self.showAddCardAlertSheet(authorization: authorization!)
            } else {
                self.gotoDashboard()
            }
        })
        
        self.createAlertDialog(title: "Wallet Fund Successful",
                               message: "Your wallet fund was successful. Your new wallet balance is \(newBalance)",
            ltrActions: [confirmAction])
      
        self.walletBalanceLabel.text = newBalance
        LoginSession.shared.dashboardInformation?.profile?.wallet = wallet
    }
    
    private func showAddCardAlertSheet(authorization: Authorization) {
        
        let actions = [
            creatAlertAction("Yes", style: .default, clicked: { _ in
                self.fundWalletPresenter.addCard(authorization: authorization)
            }),
            creatAlertAction("No", style: .default, clicked: {  _ in
                    self.gotoDashboard()
            }),
            
            creatAlertAction("Done", style: .cancel, clicked: {  _ in
                self.gotoDashboard()
            })]
        
        self.createActionSheet(title: nil, message: "Save card details for future use?",
                               ltrActions: actions,
                               preferredActionPosition: 0,
                               sender: view)
    }
}
