//
//  CardsResponse.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CardsResponse {
    
    let cards: [CreditCard]?
    
    init(_ json: JSON) {
        cards = json.arrayValue.map { CreditCard($0) }
    }
}
