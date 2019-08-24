//
//  DashboardViewController+UITableViewDelegates.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 18/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == transactionsTableView) {
            return 6
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == transactionsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier)
                as! TransactionsTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.rootView.backgroundColor = UIColor(hex: "#F8F8F8", a: 0.08)
                cell.iconImageView.image = UIImage(named: "red-arrow-down")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentInvestmentTableViewCell.identifier) as! CurrentInvestmentTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
