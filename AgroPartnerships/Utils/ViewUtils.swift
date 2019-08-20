//
//  ViewUtils.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 17/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

final class ViewUtils {
    
    static func hide(_ views: UIView...) {
        for view in views {
            view.isHidden = true
        }
    }
    
    static func show(_ views: UIView...) {
        for view in views {
            view.isHidden = false
        }
    }
}
