//
//  HelpDeskViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 31/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class HelpDeskViewController: BaseViewController {

    @IBOutlet weak var sendMessageButton: UIView!
    @IBOutlet weak var closeIconImageView: UIImageView!

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
    
    private func setupEventListeners() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapCloseIcon))
        closeIconImageView.isUserInteractionEnabled = true
        closeIconImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(userPressedSendMessageButton))
        sendMessageButton.isUserInteractionEnabled = true
        sendMessageButton.addGestureRecognizer(tap2)
    }
    
    @objc func userPressedSendMessageButton() {
        push(viewController: SupportViewController.self,
             from: StoryBoardIdentifiers.Dashboard)
    }
}
