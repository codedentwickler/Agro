//
//  LoginSession.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 24/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

class LoginSession {
    
    var isUserInSession = false
    var cards : [CreditCard] = [CreditCard]()
    var dashboardInformation: DashboardResponse?

    static let shared = LoginSession()
    private init() {}

    public func logout() {
        dashboardInformation = nil
        isUserInSession = false
    }
}
