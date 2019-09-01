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
    var cards : [CreditCard]?
    private var dashboardInformation: DashboardResponse?

    static let shared = LoginSession()
    
    private init() {}
    
    func setDashboardInformation(dashboardInformation: DashboardResponse) {
        self.dashboardInformation = dashboardInformation
    }
    
    func getDashboardInformation() -> DashboardResponse! {
         return dashboardInformation
    }
    
    public func logout() {
        dashboardInformation = nil
        isUserInSession = false
    }
}
