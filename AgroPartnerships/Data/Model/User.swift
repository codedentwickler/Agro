//
//  User.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct User {

	let id: String?
	let email: String?

	init(_ json: JSON) {
		id = json["id"].stringValue
		email = json["email"].stringValue
	}

}
