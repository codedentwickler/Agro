//
//  RegisterDeviceToken.swift
//
//  Created on September 14, 2019
//
import Foundation
import SwiftyJSON

struct RegisterDeviceTokenResponse {
	let user: User?
	let deviceType: String?
	let token: String?
	let status: String?
	let created: String?
	let updated: String?
	let Id: String?

	init(_ json: JSON) {
		user = User(json["user"])
		deviceType = json["deviceType"].stringValue
		token = json["token"].stringValue
		status = json["status"].stringValue
		created = json["created"].stringValue
		updated = json["updated"].stringValue
		Id = json["_id"].stringValue
	}
}
