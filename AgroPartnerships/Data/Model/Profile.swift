//
//  Profile.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Profile {

	let wallet: Wallet?
	let fullname: String?
	let title: String?
	let dob: String?
	let email: String?
	let phone: String?
	let bank: Bank?
	let refCode: String?
	let totalInvestment: Int?
	let totalYield: Int?
	let totalPayouts: Int?

	init(_ json: JSON) {
		wallet = Wallet(json["wallet"])
		fullname = json["fullname"].stringValue
		title = json["title"].stringValue
		dob = json["dob"].stringValue
		email = json["email"].stringValue
		phone = json["phone"].stringValue
		bank = Bank(json["bank"])
		refCode = json["refCode"].stringValue
		totalInvestment = json["totalInvestment"].intValue
		totalYield = json["totalYield"].intValue
		totalPayouts = json["totalPayouts"].intValue
	}

}
