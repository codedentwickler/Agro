//
//  Invoice.swift
//
//  Created on September 23, 2019
//
import Foundation
import SwiftyJSON

struct Invoice {
    
    let amount: Double?
    let invoiceReference: String?
    let invoiceStatus: String?
    let description: String?
    let customerEmail: String?
    let customerName: String?
    let expiryDate: String?
    let createdOn: String?
    let checkoutUrl: String?
    let accountNumber: String?
    let accountName: String?
    let bankName: String?
    let bankCode: String?
    
    init(_ json: JSON) {
        amount = json["amount"].doubleValue
        invoiceReference = json["invoiceReference"].stringValue
        invoiceStatus = json["invoiceStatus"].stringValue
        description = json["description"].stringValue
        customerEmail = json["customerEmail"].stringValue
        customerName = json["customerName"].stringValue
        expiryDate = json["expiryDate"].stringValue
        createdOn = json["createdOn"].stringValue
        checkoutUrl = json["checkoutUrl"].stringValue
        accountNumber = json["accountNumber"].stringValue
        accountName = json["accountName"].stringValue
        bankName = json["bankName"].stringValue
        bankCode = json["bankCode"].stringValue
    }
}
