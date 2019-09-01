//
//  DashboardViewController+UICollectionViewDelegates.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 17/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

extension DashboardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == portfolioActionsCollectionView {
            return portfolioActionsCollectionViewCell(collectionView, cellForItemAt: indexPath)
        } else if collectionView == walletsActionsCollectionView {
            return walletActionsCollectionViewCell(collectionView, cellForItemAt: indexPath)
        } else if collectionView == referralActionsCollectionView {
            return referralActionsCollectionViewCell(collectionView, cellForItemAt: indexPath)
        }
        
        return UICollectionViewCell()     
    }
    
    
    private func portfolioActionsCollectionViewCell(_ collectionView: UICollectionView,
                                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            DashboardActionCollectionViewCell.identifier,
                                                      for: indexPath) as! DashboardActionCollectionViewCell
        if (indexPath.row == 0) {
            cell.titleLabel.text =
            """
            Investment
            Amount
            """
            cell.backgroundImageView.image = UIImage(named: "light_green_radial_gradient")
            let totalInvestment = dashboardInformation.profile?.totalInvestment ?? 0
            cell.amountLabel.text = totalInvestment.commaSeparatedNairaValue
            let tap = UITapGestureRecognizer(target: self, action: #selector(showInvestPage))
            cell.newInvestmentButton.isUserInteractionEnabled = true
            cell.newInvestmentButton.addGestureRecognizer(tap)
        } else {
            cell.titleLabel.text = """
            Return on
            Investments
            """
            cell.backgroundImageView.image = UIImage(named: "deep_green_radial_gradient")
            cell.newInvestmentButton.isHidden = true
            let totalYield = dashboardInformation.profile?.totalYield ?? 0
            cell.amountLabel.text = totalYield.commaSeparatedNairaValue
        }
        return cell
    }
    
    private func walletActionsCollectionViewCell(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            DashboardActionThreeCollectionViewCell.identifier,
                                                      for: indexPath) as! DashboardActionThreeCollectionViewCell
        if (indexPath.row == 0) {
            cell.titleLabel.text =
            """
            Wallet
            Balance
            """
            cell.backgroundImageView.image = UIImage(named: "light_green_radial_gradient")
            cell.buttonLabel.text = "FUND WALLET"
            let withdrawable = dashboardInformation.profile?.wallet?.funds ?? 0
            let nonWithdrawable = dashboardInformation.profile?.wallet?.bonus?.balance ?? 0
            let balance = withdrawable + nonWithdrawable
            cell.amountLabel.text = balance.commaSeparatedNairaValue
            cell.subtitleLabel.text = """
            Withdrawable: \(withdrawable.commaSeparatedNairaValue)
            Non withdrawable: \(nonWithdrawable.commaSeparatedNairaValue)
            """
            let tap = UITapGestureRecognizer(target: self, action: #selector(showfundWallet))
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.addGestureRecognizer(tap)
        } else {
            cell.titleLabel.text = """
            Total
            Payout
            """
            cell.backgroundImageView.image = UIImage(named: "deep_green_radial_gradient")
            cell.buttonLabel.text = "REQUEST PAYOUT"
            cell.subtitleLabel.text = """
            Last Payout: \(dashboardInformation.lastPayoutDate()?.asDayMonthString ?? "No payout yet")
            """
            let totalPayouts = dashboardInformation.profile?.totalPayouts ?? 0
            cell.amountLabel.text = totalPayouts.commaSeparatedNairaValue
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showRequestPayout))
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.addGestureRecognizer(tap)
        }
        
        cell.buttonView.isHidden = false
        
        return cell
    }
    
    private func referralActionsCollectionViewCell(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            DashboardActionThreeCollectionViewCell.identifier,
                                                      for: indexPath) as! DashboardActionThreeCollectionViewCell
        if (indexPath.row == 0) {
            cell.backgroundImageView.image = UIImage(named: "light_green_radial_gradient")
            cell.titleLabel.text = """
            Redeemed
            Referrals
            """
            cell.subtitleLabel.textColor = UIColor.appGreen1
            cell.subtitleLabel.text = """
            Non withdrawable.
            To be spent on the platform on an investment
            """
            let totalRedeemedReferrals = dashboardInformation.totalRedeemedReferrals()
            cell.amountLabel.text = totalRedeemedReferrals.commaSeparatedNairaValue
        } else {
            cell.backgroundImageView.image = UIImage(named: "deep_green_radial_gradient")
            cell.titleLabel.text =
            """
            Pending
            Referrals
            """
            cell.amountLabel.isHidden = true
            cell.subtitleLabel.text = """
            Would be available for use when your invites
            make their first investment
            """
        }
        
        return cell
    }
    
    @objc private func showfundWallet() {
        let vc  = viewController(type: FundWalletViewController.self,
                                 from: StoryBoardIdentifiers.Wallet)
        if let cards = LoginSession.shared.cards {
            vc.cards = cards
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showRequestPayout() {
        let vc  = viewController(type: RequestPayoutViewController.self,
                                 from: StoryBoardIdentifiers.Wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showInvestPage() {
        self.tabBarController?.selectedIndex = 1
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270 , height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
