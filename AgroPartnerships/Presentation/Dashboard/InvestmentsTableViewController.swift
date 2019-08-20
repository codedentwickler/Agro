//
//  InvestmentHistoryViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 19/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class InvestmentsTableViewController: BaseViewController {
    
    public var isBeenUsedForPendingInvestments: Bool = false
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var investmentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        if isBeenUsedForPendingInvestments {
            updateUIForPendingInvestments()
        } else {
            setupUIForInvestmentsHistory()
        }
    }
    
    private func setupView() {
        
        investmentsTableView.delegate = self
        investmentsTableView.dataSource = self
        investmentsTableView.reloadData()
    }
    
    private func updateUIForPendingInvestments() {
        investmentsTableView.register(UINib(nibName: PendingInvestmentTableViewCell.identifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: PendingInvestmentTableViewCell.identifier)
    }

    private func setupUIForInvestmentsHistory() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(userTapMenuButton))
        menuIconImageView.isUserInteractionEnabled = true
        menuIconImageView.addGestureRecognizer(tap)
        
        investmentsTableView.register(UINib(nibName: InvestmentTableViewCell.identifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: InvestmentTableViewCell.identifier)
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

extension InvestmentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isBeenUsedForPendingInvestments {
            return tableView.dequeueReusableCell(withIdentifier: PendingInvestmentTableViewCell.identifier)
                as! PendingInvestmentTableViewCell
        } 
        
        return tableView.dequeueReusableCell(withIdentifier: InvestmentTableViewCell.identifier)
            as! InvestmentTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isBeenUsedForPendingInvestments {
            return 364.0
        } else {
            return 328.0
        }
    }
}
