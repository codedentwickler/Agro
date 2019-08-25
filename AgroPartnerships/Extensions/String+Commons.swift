//
//  String+Commons.swift
//  KuwegoDigital
//
//  Created by Kanyinsola Fapohunda on 23/02/2019.
//  Copyright © 2019 Kuwego. All rights reserved.
//

import Foundation

extension String {
    
    var fullRange: NSRange {
        return NSMakeRange(0, count)
    }

    
    func hasUppercase() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: self) else { return false }
        return true
    }
    
    func hasNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest.evaluate(with: self) else { return false }
        return true
    }
    
    
    public func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var intValue : Int? {
        return Int(self)
    }
    
    var doubleValue : Double? {
        return Double(self)
    }

    func asFullDate(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)!
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: finalDate)
    }
    
    var dateFromFullString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }

    public func matches(pattern: String) -> Bool {
        do{
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            NSLog("Text: \(self), Pattern: \(pattern), Matches: \(matches.count)")
            return !matches.isEmpty
        }catch {
            return false
        }
    }
    
    var digitsOnlyFromCurrency: String {
        return replacingOccurrences(of: "₦", with: "").replacingOccurrences(of: ",", with: "")
    }
}
