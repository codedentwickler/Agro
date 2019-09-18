//
//  UIScrollView.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 17/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
