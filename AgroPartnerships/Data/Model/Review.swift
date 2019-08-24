//
//  Review.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Review {

	let accountName: String?
	let accountNumber: String?
	let bankName: String?
	let date: String?

	init(_ json: JSON) {
		accountName = json["accountName"].stringValue
		accountNumber = json["accountNumber"].stringValue
		bankName = json["bankName"].stringValue
		date = json["date"].stringValue
	}

}
