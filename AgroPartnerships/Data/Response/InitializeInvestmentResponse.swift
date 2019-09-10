//
//   InitializeInvestmentResponse.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InitializeInvestmentResponse  {
    
    let investment: Investment?
    let status: String?
    let message: String?

    init(_ json: JSON) {
        investment = Investment(json["investment"])
        status = json["status"].stringValue
        message = json["message"].stringValue
    }
}
