import Foundation
import Alamofire
import SwiftyJSON

class ApiServiceImplementation : ApiService {
    
    static let shared = ApiServiceImplementation()
    
    func login(email : String,
               password: String,
               completion: @escaping (_ loginResponse: LoginResponse? ) -> Void) {
        
        let parameters = [ApiConstants.Email : email ,
                          ApiConstants.Password : password]
        
        Network.shared.request(ApiEndPoints.login(),
                        method: .post,
                        parameters: parameters,
                        completion: completion)
    }
    
    func loginWithFB(accessToken: String, completion: @escaping (LoginResponse?) -> Void) {
        let parameters = [ApiConstants.Token: accessToken]
        
        Network.shared.request(ApiEndPoints.fbSignIn(),
                               method: .post,
                               parameters: parameters,
                               completion: completion)
    }
    
    func loginWithFingerprint(email: String,
                              key: String, completion: @escaping (LoginResponse?) -> Void) {
        
        let parameters = [ApiConstants.Email : email ,
                          ApiConstants.Signature : key,
                          "deviceType": "ios"]
        
        Network.shared.request(ApiEndPoints.loginFingerprint(),
                               method: .post,
                               parameters: parameters,
                               completion: completion)
    }
    
    func forgotPassword(email: String, completion: @escaping (JSON?) -> Void) {
        Network.shared.request(ApiEndPoints.forgotPassword(),
                               method: .post,
                               parameters: [ApiConstants.Email: email],
                               completion: completion)
    }
    
    func signUp(title: String,
                fullname: String,
                email: String,
                phone: String,
                password: String,
                referral: String?,
                dob: String,
                completion: @escaping (JSON?) -> Void) {
        
        var parameters = [ApiConstants.Title : title ,
                          ApiConstants.FullName : fullname,
                          ApiConstants.Email : email,
                          ApiConstants.Password : password,
                          ApiConstants.Phone : phone,
                          ApiConstants.Dob: dob
        ]
        
        if let referral = referral {
            parameters[ApiConstants.Referral] = referral
        }
        
        Network.shared.request(ApiEndPoints.signUp(),
                        method: .post,
                        parameters: parameters,
                        completion: completion)
    }
    
    func getAvailableCommodities(limitToNumber limit: Int,
                                 completion: @escaping (AvailableCommoditiesResponse?) -> Void) {
        Network.shared.request(ApiEndPoints.getAvailableCommodities(limitToNumber: limit)) { (response) in
            if let response = response {
                completion(AvailableCommoditiesResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func getDashboardInformation(completion: @escaping (DashboardResponse?) -> Void) {
        Network.shared.request(ApiEndPoints.dashboardInformation()) { (response) in
            if let response = response {
                completion(DashboardResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func getAllCards(completion: @escaping (CardsResponse?) -> Void) {
        Network.shared.request(ApiEndPoints.cards()) { (response) in
            if let response = response {
                completion(CardsResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteCard(signature: String, completion: @escaping (String?) -> Void) {
        
        Network.shared.request(ApiEndPoints.cards(),
                               method: .delete,
                               parameters: ["signature": signature]) { (json) in
                                completion(json?[ApiConstants.Status].stringValue)
        }
    }
    
    func addCard(cardRequest: CardRequest, completion: @escaping (CreditCard?) -> Void) {
        
        Network.shared.request(ApiEndPoints.cards(),
                               method: .post,
                               parameters: cardRequest.toDictionary()) { (response) in
                if let response = response {
                    completion(CreditCard(response))
                } else {
                    completion(nil)
                }
        }
    }
    
    func initializeInvestment(item: String,
                              units: Int,
                              price: Double,
                              paymentMethod: PaymentMethod,
                              credit: Double?,
                              authCode: String?,
                              completion: @escaping (InitializeInvestmentResponse?) -> Void) {
        
        var parameters: [String : Any] = [ApiConstants.Item : item,
                          ApiConstants.Units : units,
                          ApiConstants.Price : price,
                          ApiConstants.PaymentMethod : paymentMethod.rawValue]
        
        if let credit = credit {
            parameters[ApiConstants.Credit] = credit
        }
        
        if let authCode = authCode {
            parameters[ApiConstants.AuthCode] = authCode
        }
        
        Network.shared.request(ApiEndPoints.initializeInvestment(),
                               method: .post,
                               parameters: parameters) { (response) in
            if let response = response {
                completion(InitializeInvestmentResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func rollbackInvestment(investmentReference: String,
                            completion: @escaping (RollbackInvestmentResponse?) -> Void) {
        
        Network.shared.request(ApiEndPoints.rollbackInvestment(),
                        method: .post,
                        parameters: [ApiConstants.Investment: investmentReference],
                        completion: completion)
    }
    
    func verifyInvestmentTransaction(investmentReference: String,
                                     completion: @escaping (VerifyPaymentResponse?) -> Void) {
        
        Network.shared.request(ApiEndPoints.verifyInvestmentTransaction(),
                               method: .post, parameters: [ApiConstants.Reference: investmentReference]) { (response) in
                
            if let response = response {
                completion(VerifyPaymentResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func proofOfInvestment() {
        
    }
    
    func updateProfile(parameters: [String:String],
                       completion: @escaping (JSON?) -> Void) {
        Network.shared.request(ApiEndPoints.updateProfile(),
                        method: .post,
                        parameters: parameters,
                        completion: completion)
    }
    
    func fundWalletSavedCard(amount: Double, authCode: String, completion: @escaping (FundWalletResponse?) -> Void) {
        
        let parameters: [String : Any] = [ApiConstants.Amount : amount,
                                          ApiConstants.AuthCode : authCode]
        
        Network.shared.request(ApiEndPoints.fundWallet(),
                               method: .post,
                               parameters: parameters) { (response) in
            if let response = response {
                completion(FundWalletResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func verifyWalletPayment(reference: String, completion: @escaping (FundWalletResponse?) -> Void) {
        
        Network.shared.request(ApiEndPoints.verifyWalletPayment(),
                               method: .post,
                               parameters: [ApiConstants.Reference: reference]) { (response) in
                                
                if let response = response {
                    completion(FundWalletResponse(response))
                } else {
                    completion(nil)
                }
        }
    }
    
    func requestPayout(amount: Double, completion: @escaping (RequestPayoutResponse?) -> Void) {
        
        let parameters: [String : Any] = [ApiConstants.Amount : amount]
        
        Network.shared.request(ApiEndPoints.payout(),
                               method: .post,
                               parameters: parameters) { (response) in
            if let response = response {
                completion(RequestPayoutResponse(response))
            } else {
                completion(nil)
            }
        }
    }
    
    func registerAppToken(token: String, completion: @escaping (RegisterDeviceTokenResponse?) -> Void) {
        let parameters = [ApiConstants.Token : token, "deviceType": "ios"]

        Network.shared.request(ApiEndPoints.registerFirebaseToken(),
                               method: .post,
                               parameters: parameters) { (response) in
                if let response = response {
                    completion(RegisterDeviceTokenResponse(response))
                } else {
                    completion(nil)
                }
        }
    }
    func saveFingerprint(key: String, completion: @escaping (JSON?) -> Void) {
        
        let parameters = [ApiConstants.Signature : key, "deviceType": "ios"]
        
        Network.shared.request(ApiEndPoints.fingerprint(),
                               method: .post,
                               parameters: parameters,
                               completion: completion)
    }
    
    func updateFingerprint(key: String, completion: @escaping (JSON?) -> Void) {
        let parameters = [ApiConstants.Signature : key, "deviceType": "ios"]
        
        Network.shared.request(ApiEndPoints.fingerprint(),
                               method: .put,
                               parameters: parameters,
                               completion: completion)
    }
    
    func deleteFingerprint(completion: @escaping (JSON?) -> Void) {
        let parameters = ["deviceType": "ios"]

        Network.shared.request(ApiEndPoints.fingerprint(),
                               method: .delete,
                               parameters: parameters,
                               completion: completion)
    }
    
    func generateReservedAccount(completion: @escaping (WalletBankAccount?) -> Void) {
        
       Network.shared.request(ApiEndPoints.createDBA(),
                                      method: .post) { (response) in
                   if let response = response {
                       completion(WalletBankAccount(response))
                   } else {
                       completion(nil)
                   }
               }
    }
    
}
