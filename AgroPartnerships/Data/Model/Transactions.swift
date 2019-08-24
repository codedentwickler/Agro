//
//  Transactions.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Transactions {

	let Id: String?
	let user: User?
	let type: String?
	let reference: String?
	let code: String?
	let category: String?
	let description: String?
	let amount: Int?
	let date: String?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		user = User(json["user"])
		type = json["type"].stringValue
		reference = json["reference"].stringValue
		code = json["code"].stringValue
		category = json["category"].stringValue
		description = json["description"].stringValue
		amount = json["amount"].intValue
		date = json["date"].stringValue
	}

}
