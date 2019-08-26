//
//  ManageSavedCardsViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 24/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class ManageSavedCardsViewController: UIViewController {

    public var cards: [CreditCard]!
    @IBOutlet weak var cardsTableView: UITableView!
    
    private var rightButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addEditButton()
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableView.reloadData()
    }
    
    private func addEditButton() {
        rightButtonItem = UIBarButtonItem(title: "Edit", style: .done,
                        target: self, action: #selector(userPressedEdit))
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc private func userPressedEdit() {
        if cardsTableView.isEditing {
            rightButtonItem.title = "Edit"
            cardsTableView.setEditing(false, animated: true)
        } else {
            cardsTableView.setEditing(true, animated: true)
            rightButtonItem.title = "Done"
        }
    }
}

extension ManageSavedCardsViewController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier) as! CardTableViewCell
        cell.card = cards[indexPath.row]
        return cell
    }
}

class CardTableViewCell: UITableViewCell {
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    
    
    var card : CreditCard! {
        didSet {
            bankNameLabel.text = card.bank
            cardTypeLabel.text = "\(card.bank ?? "") \u{2022} \(card.cardType?.capitalizeFirstLetter() ?? "")"
        }
    }
}
