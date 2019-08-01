//
//  ApiService.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

protocol ApiService {
    
    func login(email: String,
               password: String,
               completion: @escaping (_ response: LoginResponse? ) -> Void)
    
    func signUp(title: String,
                fullname: String,
                email: String,
                phone: String,
                password: String,
                referral: String?,
                dob: String,
                completion: @escaping (_ response: SignUpResponse? ) -> Void)
    
    func getAvailableCommodities(limitToNumber limit: Int,
                                 completion: @escaping (_ response: AvailableCommoditiesResponse? ) -> Void)
    
    func getDashboardInformation(completion: @escaping (_ response: DashboardInformationResponse? ) -> Void)
    
    func initializeInvestment(item: String,
                              units: Int,
                              price: Decimal,
                              paymentMethod: PaymentMethod,
                              credit: Decimal?,
                              completion: @escaping (_ response: InitializeInvestmentResponse? ) -> Void)
    
    func rollbackInvestment(investmentReference: String,
                            completion: @escaping (_ response: RollbackInvestmentResponse? ) -> Void)
    
    func verifyInvestmentTransaction(investmentReference: String,
                                     completion: @escaping (_ response: VerifyInvestmentTransactionResponse? ) -> Void)
    
    func proofOfInvestment()
    
    func updateProfile(dob: String?,
                       fullname: String?,
                       phone: String?,
                       title: String?,
                       completion: @escaping (_ response: ProfileUpdateResponse? ) -> Void)
}
