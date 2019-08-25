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
        if tableView == transactionsTableView {
            return dashboardInformation.transactions?.count ?? 0
        } else if tableView == currentInvestmentsTableView {
            return currentInvestments.count 
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == transactionsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier)
                as! TransactionsTableViewCell
            
            guard let transaction = dashboardInformation.transactions?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.transaction = transaction
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentInvestmentTableViewCell.identifier) as! CurrentInvestmentTableViewCell
            cell.portfolio = currentInvestments[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
