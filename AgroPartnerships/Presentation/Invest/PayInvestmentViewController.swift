//
//  PayInvestmentViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import UIKit

class PayInvestmentViewController: BaseViewController {
    
    public var cards: [CreditCard]!
    
    @IBOutlet weak var selectedCardBankNameLabel: UILabel!
    @IBOutlet weak var selectedCardTypeLabel: UILabel!
    @IBOutlet weak var selectedCardIconImageView: UIImageView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var amountView: AmountInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        
        let profile = LoginSession.shared.dashboardInformation?.profile
        walletBalanceLabel.text = profile?.wallet?.funds?.commaSeparatedNairaValue
    }
    
    @IBAction func userPressedFundWallet(_ sender: Any) {
        
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

extension PayInvestmentViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        selectedCardIconImageView.image = UIImage(named: imageBackgroundForCard(at: indexPath.row))
        selectedCardBankNameLabel.text = card.bank
        selectedCardTypeLabel.text = "\(card.cardType?.capitalizeFirstLetter() ?? "") \u{2022} \( card.last4 ?? "")"
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
