import Foundation

extension Double {
    
    var intValue : Int {
        return Int(self)
    }
    
    var string: String {
        return String(self)
    }
}

extension Float {
    var intValue: Int {
        return Int(self)
    }
}

extension Int {
    var string: String {
        return String(self)
    }
    
    var doubleValue : Double {
        return Double(self)
    }
    
    var commaSeparatedNairaValue : String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencySymbol = "₦"
        return "\(numberFormatter.string(from: NSNumber(value: self))!)"
    }
}

extension Bool {
    
    var string: String {
        return String(self)
    }
}
