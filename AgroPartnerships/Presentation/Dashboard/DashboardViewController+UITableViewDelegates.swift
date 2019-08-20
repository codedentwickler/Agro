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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentInvestmentTableViewCell.identifier) as! CurrentInvestmentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
