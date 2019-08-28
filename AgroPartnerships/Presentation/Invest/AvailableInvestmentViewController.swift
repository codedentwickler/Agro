//
//  AvailableInvestmentViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 26/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class AvailableInvestmentViewController: BaseViewController {
    
    public var isBeenUsedForSoldOutInvestments: Bool = false
    internal var investments: [Investment]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var investmentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isBeenUsedForSoldOutInvestments {
            updateUIForSoldOutInvestments()
        } else {
            setupUIForAvailableInvestments()
        }
        setupView()
    }
    
    private func setupView() {
        investmentsTableView.delegate = self
        investmentsTableView.dataSource = self
        investmentsTableView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(userTapMenuButton))
        menuIconImageView.isUserInteractionEnabled = true
        menuIconImageView.addGestureRecognizer(tap)
        
        investmentsTableView.register(UINib(nibName: SoldOutInvestmentTableViewCell.identifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: SoldOutInvestmentTableViewCell.identifier)
    }
    
    private func updateUIForSoldOutInvestments() {
        titleLabel.text = "Sold Out Investments"
    }
    
    private func setupUIForAvailableInvestments() {
        titleLabel.text = "Available Investments"
    }
    
    @objc private func userTapMenuButton() {
        
        let actions = [
            creatAlertAction("Sort by Date (Most recent)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Sort by Amount Invested (Highest)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Sort by Units bought (High to low)", style: .default, clicked: { _ in
                
            }),
            creatAlertAction("Cancel", style: .cancel, clicked: { _ in
                
            })
        ]
        
        createActionSheet(ltrActions: actions)
    }
}

extension AvailableInvestmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SoldOutInvestmentTableViewCell.identifier)
            as! SoldOutInvestmentTableViewCell
        cell.investment = investments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
