//
//  Payment.swift
//
//  Created on September 07, 2019
//
import Foundation
import SwiftyJSON

struct Payment {

    let method: String?
    let amount: Int
    let status: String?
    let key: String?
    let email: String?
	let wallet: Int?

	init(_ json: JSON) {
		method = json["method"].stringValue
		status = json["status"].stringValue
        wallet = json["wallet"].intValue
        key = json["key"].stringValue
        email = json["email"].stringValue
        amount = json["amount"].intValue
	}

}
