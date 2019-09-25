//
//  TermsAndConditionsViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 03/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController : BaseViewController {
    
    @IBOutlet weak var pageSwitch: UISegmentedControl!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageSwitch.selectedSegmentIndex = 0
        userChangedPageSegmentedControl(pageSwitch)
    }
    
    @IBAction func userChangedPageSegmentedControl(_ sender: UISegmentedControl) {
        
        var html = ""
        switch sender.selectedSegmentIndex {
        case 0: html = FileUtils.readHTMLResourceFile(fileName: "Terms_of_use")
        case 1: html = FileUtils.readHTMLResourceFile(fileName: "Privacy")
        case 2: html = FileUtils.readHTMLResourceFile(fileName: "Cookie_Policy")

        default:
            break
        }
        
        contentTextView.setHTMLFromString(htmlText: html)
    }
}

