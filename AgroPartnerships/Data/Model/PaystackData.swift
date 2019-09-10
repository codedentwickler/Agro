//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 08, 2019
//
import Foundation
import SwiftyJSON

struct PaystackData {

	let id: Int?
	let domain: String?
	let status: String?
	let reference: String?
	let amount: Int?
	let message: Any?
	let gatewayResponse: String?
	let paidAt: String?
	let createdAt: String?
	let channel: String?
	let currency: String?
	let ipAddress: Any?
	let metadata: Int?
	let log: Any?
	let fees: Int?
	let feesSplit: Any?
	let authorization: Authorization?
	let customer: Customer?
	let plan: Any?
	let orderId: Any?
	let transactionDate: String?

	init(_ json: JSON) {
		id = json["id"].intValue
		domain = json["domain"].stringValue
		status = json["status"].stringValue
		reference = json["reference"].stringValue
		amount = json["amount"].intValue
		message = json["message"]
		gatewayResponse = json["gateway_response"].stringValue
		paidAt = json["paid_at"].stringValue
		createdAt = json["created_at"].stringValue
		channel = json["channel"].stringValue
		currency = json["currency"].stringValue
		ipAddress = json["ip_address"]
		metadata = json["metadata"].intValue
		log = json["log"]
		fees = json["fees"].intValue
		feesSplit = json["fees_split"]
		authorization = Authorization(json["authorization"])
		customer = Customer(json["customer"])
		plan = json["plan"]
		orderId = json["order_id"]
		transactionDate = json["transaction_date"].stringValue
	}

}
