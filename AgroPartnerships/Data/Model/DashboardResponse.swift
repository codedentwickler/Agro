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
}
