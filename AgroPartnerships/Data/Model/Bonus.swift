//
//  Bonus.swift
//
//  Created on August 24, 2019
//
import Foundation
import SwiftyJSON

struct Bonus {

	let balance: Int?
	let pending: Int?

	init(_ json: JSON) {
		balance = json["balance"].intValue
		pending = json["pending"].intValue
	}

}
