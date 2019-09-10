//
//  VerifyPaymentResponse.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 08, 2019
//
import Foundation
import SwiftyJSON

struct VerifyPaymentResponse {

	let status: String?
	let message: String?
	let data: PaystackData?

	init(_ json: JSON) {
		status = json["status"].stringValue
		message = json["message"].stringValue
		data = PaystackData(json["data"])
	}

}
