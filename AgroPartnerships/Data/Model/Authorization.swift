//
//  Authorization.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 08, 2019
//
import Foundation
import SwiftyJSON

struct Authorization {

	let authorizationCode: String?
	let bin: String?
	let last4: String?
	let expMonth: String?
	let expYear: String?
	let channel: String?
	let cardType: String?
	let bank: String?
	let countryCode: String?
	let brand: String?
	let reusable: Bool?
	let signature: String?

	init(_ json: JSON) {
		authorizationCode = json["authorization_code"].stringValue
		bin = json["bin"].stringValue
		last4 = json["last4"].stringValue
		expMonth = json["exp_month"].stringValue
		expYear = json["exp_year"].stringValue
		channel = json["channel"].stringValue
		cardType = json["card_type"].stringValue
		bank = json["bank"].stringValue
		countryCode = json["country_code"].stringValue
		brand = json["brand"].stringValue
		reusable = json["reusable"].boolValue
		signature = json["signature"].stringValue
	}

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["authorization_code"] = authorizationCode
        jsonDict["bin"] = bin
        jsonDict["last4"] = last4
        jsonDict["exp_month"] = expMonth
        jsonDict["exp_year"] = expYear
        jsonDict["channel"] = channel
        jsonDict["card_type"] = cardType
        jsonDict["bank"] = bank
        jsonDict["country_code"] = countryCode
        jsonDict["brand"] = brand
        jsonDict["reusable"] = reusable
        jsonDict["signature"] = signature
        return jsonDict
    }
}
