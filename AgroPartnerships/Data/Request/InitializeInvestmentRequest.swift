//
//  InitializeTransactionRequest.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

struct InitializeInvestmentRequest {
    
    let item: String
    let units: Int
    let price: Int
    var credit: Int?
    let amountLeft: Int
    var paymentMethod: PaymentMethod
    var authCode: String?
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["item"] = item
        jsonDict["units"] = units
        jsonDict["price"] = price
        jsonDict["credit"] = credit
        jsonDict["paymentMethod"] = paymentMethod
        jsonDict["authCode"] = authCode
        return jsonDict
    }
}
