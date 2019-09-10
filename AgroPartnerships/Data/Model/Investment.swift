//
//  Investment.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Investment {

	let Id: String?
	let code: String?
	let description: String?
	let duration: String?
	let insurance: String?
	let location: String?
	let picture: String?
    let amount: Int?
	let price: Int?
    let payment: Payment?
	let status: String?
	let title: String?
	let totalUnits: Int?
	let type: String?
	let units: Int?
	let yield: Int?
    let user: User?

	init(_ json: JSON) {
		Id = json["_id"].stringValue
		code = json["code"].stringValue
		description = json["description"].stringValue
		duration = json["duration"].stringValue
		insurance = json["insurance"].stringValue
		location = json["location"].stringValue
		picture = json["picture"].stringValue
		price = json["price"].intValue
        payment = Payment(json["payment"])
        amount = json["amount"].intValue
		status = json["status"].stringValue
		title = json["title"].stringValue
		totalUnits = json["totalUnits"].intValue
		type = json["type"].stringValue
		units = json["units"].intValue
		yield = json["yield"].intValue
        user = User(json["user"])
	}
}
