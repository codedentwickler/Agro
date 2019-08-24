//
//  Double.swift
//  KuwegoDigital
//
//  Created by Kanyinsola Fapohunda on 28/04/2019.
//  Copyright © 2019 Kuwego. All rights reserved.
//

import Foundation

public extension Double{
    
    public func asMoney(withDecimal: Bool = true) -> String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en_US")
        currencyFormatter.negativeFormat = "-0.00"
        
        var value: Double = self
        
        if !withDecimal{
            value = Double(Int(self))
        }
        
        var money = currencyFormatter.string(from: NSNumber(value: value))!
        
        if value < 0 {
            money = "-\(money)"
        }
        
        money = money.replacingCharacters(in: money.startIndex..<money.index(after: money.startIndex),
                                          with: "")
        
        if !withDecimal {
            money = money.replacingOccurrences(of: ".00", with: "")
        }
        
        return money
    }
}
