//
//  CardRequest.swift
//
//  Created on August 25, 2019
//
import Foundation

struct CardRequest {

	let authorizationCode: String?
	let cardType: String?
	let last4: String?
	let expMonth: String?
	let expYear: String?
	let bin: String?
	let bank: String?
	let signature: String?

	func toDictionary() -> [String: String?] {
		var jsonDict = [String: String]()
		jsonDict["authorization_code"] = authorizationCode
		jsonDict["card_type"] = cardType
		jsonDict["last4"] = last4
		jsonDict["exp_month"] = expMonth
		jsonDict["exp_year"] = expYear
		jsonDict["bin"] = bin
		jsonDict["bank"] = bank
		jsonDict["signature"] = signature
		return jsonDict
	}

}
