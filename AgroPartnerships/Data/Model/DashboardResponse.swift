//
//  DashboardResponse.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct DashboardResponse {

	let portfolio: [Portfolio]?
	let transactions: [Transactions]?
	let referrals: [Any]?
	let profile: Profile?
	let paystackKey: String?
	let status: String?

	init(_ json: JSON) {
		portfolio = json["portfolio"].arrayValue.map { Portfolio($0) }
		transactions = json["transactions"].arrayValue.map { Transactions($0) }
		referrals = json["referrals"].arrayValue.map { $0 }
		profile = Profile(json["profile"])
		paystackKey = json["paystackKey"].stringValue
		status = json["status"].stringValue
	}

    public func isSuccessful() -> Bool {
        return status == "success"
    }
    
    public func lastPayoutDate() -> Date? {
        
        guard let transactions = transactions else {
            return nil
        }
        
        let lastPayoutDate = transactions.filter({ $0.category == ApiConstants.Payout })
            .sorted(by: {$1.date!.dateFromFullString!.compare($1.date!.dateFromFullString!)
                == .orderedDescending}).first?.date?.dateFromFullString ?? nil
        
        return lastPayoutDate
    }
    
    public func totalPayout() -> Int {
        
        guard let transactions = transactions else {
            return 0
        }
        
        var total = 0
        
        for transaction in transactions {
            if transaction.category == ApiConstants.Payout {
                total += transaction.amount ?? 0
            }
        }
        
        return total
    }
    
    
    public func totalRedeemedReferrals() -> Int {
        
        guard let referrals = referrals else {
            return 0
        }
        
        var total = 0
        
        return total
    }
}
