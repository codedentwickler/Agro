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
    
    
    func portfolioActionsCollectionViewCell(_ collectionView: UICollectionView,
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
        } else {
            cell.titleLabel.text = """
            Return on
            Investments
            """
            cell.backgroundImageView.image = UIImage(named: "deep_green_radial_gradient")
            cell.newInvestmentButton.isHidden = true
        }
        return cell
    }
    
    func walletActionsCollectionViewCell(_ collectionView: UICollectionView,
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
            cell.subtitleLabel.text = """
            Withdrawable:
            Non withdrawable:
            """
        } else {
            cell.titleLabel.text = """
            Total
            Payout
            """
            cell.backgroundImageView.image = UIImage(named: "deep_green_radial_gradient")
            cell.buttonLabel.text = "REQUEST PAYOUT"
            cell.subtitleLabel.text = """
            Last Payout: (Date)
            """
        }
        
        cell.buttonView.isHidden = false
        
        return cell
    }
  
    
    func referralActionsCollectionViewCell(_ collectionView: UICollectionView,
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
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270 , height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
