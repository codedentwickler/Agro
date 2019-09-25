//
//  WalletBankAccount.swift
//
//  Created on September 23, 2019
//

import Foundation
import SwiftyJSON

struct WalletBankAccount {
    
    let Id: String?
    let user: User?
    let accountReference: String?
    let accountName: String?
    let currencyCode: String?
    let customerEmail: String?
    let customerName: String?
    let accountNumber: String?
    let bankName: String?
    let bankCode: String?
    let reservationReference: String?
    let status: String?
    let created: String?
    
    init(_ json: JSON) {
        Id = json["_id"].stringValue
        user = User(json["user"])
        accountReference = json["accountReference"].stringValue
        accountName = json["accountName"].stringValue
        currencyCode = json["currencyCode"].stringValue
        customerEmail = json["customerEmail"].stringValue
        customerName = json["customerName"].stringValue
        accountNumber = json["accountNumber"].stringValue
        bankName = json["bankName"].stringValue
        bankCode = json["bankCode"].stringValue
        reservationReference = json["reservationReference"].stringValue
        status = json["status"].stringValue
        created = json["created"].stringValue
    }
    
}
