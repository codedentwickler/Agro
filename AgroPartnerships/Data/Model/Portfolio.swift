//
//  Portfolio.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Portfolio {

	let Id: String?
	let code: String?
	let units: Int?
	let price: Int?
	let amount: Int?
	let yield: Int?
	let status: String?
	let startDate: String?
	let endDate: String?
	let investment: Investment?
	let updates: [Any]?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		code = json["code"].stringValue
		units = json["units"].intValue
		price = json["price"].intValue
		amount = json["amount"].intValue
		yield = json["yield"].intValue
		status = json["status"].stringValue
		startDate = json["startDate"].stringValue
		endDate = json["endDate"].stringValue
		investment = Investment(json["investment"])
		updates = json["updates"].arrayValue.map { $0 }
	}

}
