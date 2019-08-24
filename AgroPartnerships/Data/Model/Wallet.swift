//
//  Wallet.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Wallet {

	let funds: Int?
	let ledger: Int?
	let bonus: Bonus?

	init(_ json: JSON) {
		funds = json["funds"].intValue
		ledger = json["ledger"].intValue
		bonus = Bonus(json["bonus"])
	}

}
