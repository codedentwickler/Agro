//
//  TermsAndConditionsViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 03/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController : UIViewController {
    
    @IBOutlet weak var pageSwitch: UISegmentedControl!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func userChangedPageSegmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: contentTextView.text = "Page 1"
        case 1: contentTextView.text = "Page 2"
        case 2: contentTextView.text = "Page 3"

        default:
            break
        }
    }
}

