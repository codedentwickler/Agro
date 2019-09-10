//
//  PayInvestmentViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Paystack
import FittedSheets

class PayInvestmentViewController: BaseViewController {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedCardBankNameLabel: UILabel!
    @IBOutlet weak var selectedCardTypeLabel: UILabel!
    @IBOutlet weak var selectedCardIconImageView: UIImageView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var selectedCardView: UIView!
    @IBOutlet weak var selectedCardViewHeight: NSLayoutConstraint!

    public var initializeTransactionRequest: InitializeInvestmentRequest!
    
    private var payInvestmentPresenter: PayInvestmentPresenter!
    private var selectedCard : CreditCard? = nil {
        didSet {
            if let selectedCard = selectedCard {
                switch selectedCard.cardType?.trim() {
                case "visa":
                    selectedCardIconImageView.image = UIImage.pstck_visaCard()
                case "mastercard":
                    selectedCardIconImageView.image = UIImage.pstck_masterCardCard()
                case "verve": //pstck_card_verve
                    selectedCardIconImageView.image = UIImage.pstck_brandImage(for: .verve)
                default:
                    selectedCardIconImageView.image = UIImage.pstck_unknownCardCard()
                }
                
                selectedCardBankNameLabel.text = selectedCard.bank
                selectedCardTypeLabel.text = "\(selectedCard.cardType?.capitalizeFirstLetter() ?? "") \u{2022} \( selectedCard.last4 ?? "")"
                selectedCardView.isHidden = false
                selectedCardViewHeight.constant = CGFloat(112.0)
            
                if oldValue == nil {
                    contentViewHeight.constant = contentViewHeight.constant + selectedCardViewHeight.constant
                    contentViewHeight.isActive = true
                }
            }
        }
    }
    
    private var cards: [CreditCard]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        payInvestmentPresenter = PayInvestmentPresenter(apiService: ApiServiceImplementation.shared,
                                                        view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        cards = LoginSession.shared.cards
        
        if cards.isEmpty {
            cardsCollectionView.isHidden = true
            cardsCollectionViewHeight.constant = 0
            cardsCollectionViewHeight.isActive = true
             contentViewHeight.constant = CGFloat(600.0)
            contentViewHeight.isActive = true
        }

        let amountString = initializeTransactionRequest?.price.commaSeparatedNairaValue ?? ""
        amountLabel.text = amountString
        unitsLabel.text = initializeTransactionRequest?.units.string ?? ""
    }
    
    @IBAction func userPressedFundWallet(_ sender: Any) {
        if let selectedCard = selectedCard {
            initializeTransactionRequest.authCode = selectedCard.authorizationCode
            initializeTransactionRequest.paymentMethod = .cardAuth
            payInvestmentPresenter.initializeInvestment(initializeTransactionRequest)
        } else {
            // Integrate new Card flow
            enterNewCardInformationModal()
        }
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
    
    private func enterNewCardInformationModal() {
        let vc = PaymentViewController()
        vc.delegate = self
        
        let sheetController = SheetViewController(controller: vc,
                                                  sizes: [SheetSize.fixed(200)])
        sheetController.dismissOnBackgroundTap = true
        present(sheetController, animated: true, completion: nil)
    }
}

extension PayInvestmentViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
    }
}

extension PayInvestmentViewController : UICollectionViewDataSource {
    
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

extension PayInvestmentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270 , height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension PayInvestmentViewController: PayInvestmentView {
    
    func showCardAddedDialog() {
        
        self.createAlertDialog(title: "Card Added Successfully",
                               message: "You can now use this card to pay in the future",
                               ltrActions: [creatAlertAction("Ok",style: .default, clicked: { _ in
            self.gotoDashboard()
        })])
    }
    
    func showInvestmentSuccessfulDialog(units: Int, amountPaid: Int, authorization: Authorization?) {
        let message = "Your investment for \(units) units \(amountPaid.commaSeparatedNairaValue) was successful"
        
        let confirmAction = creatAlertAction("Confirm", style: .default, clicked: { _ in
            if authorization != nil && authorization?.reusable == true {
                self.showAddCardAlertSheet(authorization: authorization!)
            } else {
                self.gotoDashboard()
            }
        })
        
        createAlertDialog(title: "Investment Successful",
                          message: message,
                          ltrActions: [confirmAction])
    }
    
    private func showAddCardAlertSheet(authorization: Authorization) {
        
        let actions = [
            creatAlertAction("Yes", style: .default, clicked: { _ in
                self.payInvestmentPresenter.addCard(authorization: authorization)
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

extension PayInvestmentViewController: ProvideCardInformationDelegate {
    func userProvidedValidCardInfo(cardParams: PSTCKCardParams) {
        initializeTransactionRequest.paymentMethod = .card
        payInvestmentPresenter.initializeInvestmentWithNewCard(initializeTransactionRequest,
                                                                  cardParams: cardParams,
                                                                  viewcontroller: self)
    }
}
