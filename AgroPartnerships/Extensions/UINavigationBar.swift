//
//  UINavigationBar.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 27/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func makeNavigationBarTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func returnNavigationBarToDefault() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.isTranslucent = false
    }
}
