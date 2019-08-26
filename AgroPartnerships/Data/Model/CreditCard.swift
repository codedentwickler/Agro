//
//  Card.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on August 25, 2019
//
import Foundation
import SwiftyJSON

struct CreditCard {

	let Id: String?
	let user: User?
	let authorizationCode: String?
	let cardType: String?
	let last4: String?
	let expMonth: String?
	let expYear: String?
	let bin: String?
	let bank: String?
	let signature: String?
	let status: String?
	let created: String?
	let updated: String?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		user = User(json["user"])
		authorizationCode = json["authorization_code"].stringValue
		cardType = json["card_type"].stringValue
		last4 = json["last4"].stringValue
		expMonth = json["exp_month"].stringValue
		expYear = json["exp_year"].stringValue
		bin = json["bin"].stringValue
		bank = json["bank"].stringValue
		signature = json["signature"].stringValue
		status = json["status"].stringValue
		created = json["created"].stringValue
		updated = json["updated"].stringValue
	}

}
