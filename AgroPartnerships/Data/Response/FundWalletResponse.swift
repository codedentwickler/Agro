//
//  FundWalletResponse.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 01/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FundWalletResponse {
    
    let wallet: Wallet?
    let transactionId: String?
    let payment: VerifyPaymentResponse?
    let status: String?
    let message: String?

    init(_ json: JSON) {
        wallet = Wallet(json["wallet"])
        payment = VerifyPaymentResponse(json["payment"])
        transactionId = json["transactionId"].stringValue
        status = json["status"].stringValue
        message = json["message"].stringValue
    }
}
