//
//  AgroLogger.swift
//  AmahiAnywhere
//
//  Created by Kanyinsola on 10/08/2018.
//  Copyright © 2018 Kanyinsola. All rights reserved.
//

import Foundation

class AgroLogger {
    public static func log(_ items: Any...) {
        // Only allowing in DEBUG mode
        #if DEBUG
            debugPrint(items)
        #endif
    }
}
