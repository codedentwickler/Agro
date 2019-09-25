//
//  ApiService.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ApiService {
    
    func login(email: String,
               password: String,
               completion: @escaping (_ response: LoginResponse? ) -> Void)
    
    func loginWithFingerprint(email: String,
                              key: String,
                              completion: @escaping (_ response: LoginResponse? ) -> Void)
    
    func saveFingerprint(key: String,
                         completion: @escaping (_ response: JSON? ) -> Void)
    
    func updateFingerprint(key: String,
                           completion: @escaping (_ response: JSON? ) -> Void)
    
    func deleteFingerprint(completion: @escaping (_ response: JSON? ) -> Void)
    
    func forgotPassword(email: String,
                        completion: @escaping (_ response: JSON? ) -> Void)
    
    func signUp(title: String,
                fullname: String,
                email: String,
                phone: String,
                password: String,
                referral: String?,
                dob: String,
                completion: @escaping (_ response: JSON? ) -> Void)
    
    func getAvailableCommodities(limitToNumber limit: Int,
                                 completion: @escaping (_ response: AvailableCommoditiesResponse? ) -> Void)
    
    func getDashboardInformation(completion: @escaping (_ response: DashboardResponse? ) -> Void)
    
    func initializeInvestment(item: String,
                              units: Int,
                              price: Double,
                              paymentMethod: PaymentMethod,
                              credit: Double?,
                              authCode: String?,
                              completion: @escaping (_ response: InitializeInvestmentResponse? ) -> Void)
    
    func rollbackInvestment(investmentReference: String,
                            completion: @escaping (_ response: RollbackInvestmentResponse? ) -> Void)
    
    func verifyInvestmentTransaction(investmentReference: String,
                                     completion: @escaping (_ response: VerifyPaymentResponse? ) -> Void)
    
    func proofOfInvestment()
    
    func updateProfile(parameters: [String:String],
                       completion: @escaping (JSON?) -> Void)
    
    func getAllCards(completion: @escaping (_ response: CardsResponse? ) -> Void)
    
    func deleteCard(signature: String, completion: @escaping (_ status: String? ) -> Void)
    
    func addCard(cardRequest: CardRequest, completion: @escaping (_ response: CreditCard? ) -> Void)
    
    func fundWalletSavedCard(amount: Double, authCode: String, completion: @escaping (_ response: FundWalletResponse? ) -> Void)
    
    func verifyWalletPayment(reference: String,
                             completion: @escaping (_ response: FundWalletResponse? ) -> Void)
    
    func requestPayout(amount: Double, completion: @escaping (_ response: RequestPayoutResponse? ) -> Void)
    
    func registerAppToken(token: String, completion: @escaping (_ response: RegisterDeviceTokenResponse? ) -> Void)
}

typealias RequestPayoutResponse = FundWalletResponse
typealias CardRequest = Authorization
