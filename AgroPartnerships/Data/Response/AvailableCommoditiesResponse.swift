//
//  AvailableCommoditiesResponse.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AvailableCommoditiesResponse {
    
    let investments: [Investment]?
    
    init(_ json: JSON) {
        investments = json.arrayValue.map { Investment($0) }
    }
}
