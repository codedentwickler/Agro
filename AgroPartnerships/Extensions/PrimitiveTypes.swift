import UIKit
import Foundation

extension String {
    public func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
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
    
    var asDate: String! {
        let string = self.prefix(10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: String(string))!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)!
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: finalDate)
    }
    
    var dateFromFullString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    // formatting text for currency textField in ₦aira
    var currencyInputFormatting : String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "₦"
        formatter.maximumFractionDigits = 0
        
        var amountWithPrefix = self
        
        // remove from String: "₦", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        var number: NSNumber!
        number = NSNumber(value: double)
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    var digitsOnlyFromCurrency: String {
        return replacingOccurrences(of: "₦", with: "").replacingOccurrences(of: ",", with: "")
    }
}

extension Double {
    
    var intValue : Int {
        return Int(self)
    }
  
    var commaSeparatedValue : String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.currencySymbol = "₦"
        return "\(numberFormatter.string(from: NSNumber(value: self))!)"
    }
    
    var string: String! {
        return String(self)
    }
}

extension Float {
    
    var intValue: Int {
        return Int(self)
    }
}

extension Int {

    var fullYearDescription: String {
        return (self <= 1) ? "\(self) year" : "\(self) years"
    }
    
    var string: String! {
        return String(self)
    }
}

extension Bool {
    
    var string: String! {
        return String(self)
    }
}
