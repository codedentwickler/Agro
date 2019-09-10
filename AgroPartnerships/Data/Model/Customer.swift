//
//  Customer.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 08, 2019
//
import Foundation
import SwiftyJSON

struct Customer {

	let id: Int?
	let firstName: String?
	let lastName: String?
	let email: String?
	let customerCode: String?
	let phone: String?
	let metadata: Any?
	let riskAction: String?

	init(_ json: JSON) {
		id = json["id"].intValue
		firstName = json["first_name"].stringValue
		lastName = json["last_name"].stringValue
		email = json["email"].stringValue
		customerCode = json["customer_code"].stringValue
		phone = json["phone"].stringValue
		metadata = json["metadata"]
		riskAction = json["risk_action"].stringValue
	}

}