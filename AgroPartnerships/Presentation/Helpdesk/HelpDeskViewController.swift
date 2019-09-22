//
//  HelpDeskViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 31/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import CoreLocation

class HelpDeskViewController: BaseViewController {

    @IBOutlet weak var sendMessageButton: UIView!
    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet var contactPhoneNumbersLabels: [UILabel]!
    @IBOutlet weak var emailSupportLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    
    let phoneNumbers = [ "+2348098111113", "+2348098111114", "+2349030000395"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupEventListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func userPressedSupportPhone(gesture: UITapGestureRecognizer) {
        let index = contactPhoneNumbersLabels.index(of: gesture.view as! UILabel) ?? 0
        let phone = phoneNumbers[index]
        openDialer(withPhone: phone)
    }
    
    private func openDialer(withPhone phone: String) {
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
            UIApplication.shared.open(url)
            } else {
            UIApplication.shared.openURL(url)
        }
    }
}
    
    private func setupEventListeners() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapCloseIcon))
        closeIconImageView.isUserInteractionEnabled = true
        closeIconImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(userPressedSendMessageButton))
        sendMessageButton.isUserInteractionEnabled = true
        sendMessageButton.addGestureRecognizer(tap2)
        
        for view in contactPhoneNumbersLabels {
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(userPressedSupportPhone(gesture:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap1)
        }
        for view in [locationIcon, addressLabel] {

            let tap3 = UITapGestureRecognizer(target: self, action: #selector(userPressedAddressLabel))
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(tap3)
        }
    }
    
    @objc func userPressedSendMessageButton() {
        push(viewController: SupportViewController.self,
             from: StoryBoardIdentifiers.Dashboard)
    }
    
    @objc func userPressedAddressLabel() {
        let locationString = "Farmforte, 8 The Rock Dr, Lekki Phase 1, Lagos, Nigeria"
        let query = "?ll=6.4397324,3.4709245" // farm forte coordinates.
        
        let urlString = "http://maps.apple.com/".appending(query)
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
