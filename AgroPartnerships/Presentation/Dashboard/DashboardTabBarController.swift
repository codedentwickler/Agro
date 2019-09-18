//
//  DashboardTabBarController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 12/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class DashboardTabBarController: UITabBarController {
    
    public var showSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = true
    }
}
