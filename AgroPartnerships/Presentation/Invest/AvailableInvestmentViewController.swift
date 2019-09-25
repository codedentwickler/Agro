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
    var investments: [Investment] = [Investment]()
    
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
        
        if investments.count == 0 {
            investmentsTableView.setEmptyMessage("No sold out investment")
        }
    }
    
    private func setupUIForAvailableInvestments() {
        titleLabel.text = "Available Investments"
        
        if investments.count == 0 {
            investmentsTableView.setEmptyMessage("No available investment at the moment")
        }
    }
    
    @objc private func userTapMenuButton() {
        var sortedInvestments = [Investment]()
        var actions = [UIAlertAction]()
        actions.append(creatAlertAction("Sort by Cost (High to low)", style: .default, clicked: { _ in
            sortedInvestments = self.investments.sorted(by: {$0.price! > $1.price!})
            self.updateListOnSortingOrderChanged(sortedInvestments: sortedInvestments)
        }))
        
        actions.append(creatAlertAction("Cancel", style: .cancel, clicked: nil))

        createActionSheet(ltrActions: actions)
    }
    
    private func updateListOnSortingOrderChanged(sortedInvestments: [Investment]) {
        self.investments = sortedInvestments
        investmentsTableView.reloadData()
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
        showInvestmentDetail(investment: investments[indexPath.row])
    }
    
    private func showInvestmentDetail(investment: Investment) {
        let vc = viewController(type: InvestDetailViewController.self, from: StoryBoardIdentifiers.Invest)
        vc.investments = investments
        vc.investment = investment
        navigationController?.pushViewController(vc, animated: true)
    }
}
