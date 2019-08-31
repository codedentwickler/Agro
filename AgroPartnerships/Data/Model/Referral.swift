//
//  Referral.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Referral {
    
    let Id: String?
    let userFullName: String?
    let date: String?
    let amount: Int?
    
    init(_ json: JSON) {
        Id = json["_id"].stringValue
        userFullName = json["user"]["fullname"].stringValue
        date = json["date"].stringValue
        amount = json["amount"].intValue
    }
}
