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
                          ApiConstants.Phone : phone ]
        
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
        
        Network.shared.request(ApiEndPoints.getAvailableCommodities(limitToNumber: limit), completion: completion)
    }
    
    func getDashboardInformation(completion: @escaping (DashboardResponse?) -> Void) {
        Network.shared.request(ApiEndPoints.getDashboardInformation()) { (response) in
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
        
        Network.shared.request(ApiEndPoints.cards(), method: .delete,
                               parameters: ["signature": signature]) { (json) in
                                completion(json?[ApiConstants.Status].stringValue)
        }
    }
    
    func addCard(cardRequest: CardRequest, completion: @escaping (CreditCard?) -> Void) {
        
    }
    
    func initializeInvestment(item: String,
                              units: Int,
                              price: Decimal,
                              paymentMethod: PaymentMethod,
                              credit: Decimal?,
                              completion: @escaping (InitializeInvestmentResponse?) -> Void) {
        
        var parameters: [String : Any] = [ApiConstants.Item : item,
                          ApiConstants.Units : units,
                          ApiConstants.Price : price,
                          ApiConstants.PaymentMethod : paymentMethod]
        
        if let credit = credit {
            parameters[ApiConstants.Credit] = credit
        }
        Network.shared.request(ApiEndPoints.initializeInvestment(),
                        method: .post,
                        parameters: parameters,
                        completion: completion)
    }
    
    func rollbackInvestment(investmentReference: String,
                            completion: @escaping (RollbackInvestmentResponse?) -> Void) {
        
        Network.shared.request(ApiEndPoints.rollbackInvestment(),
                        method: .post,
                        parameters: [ApiConstants.Investment: investmentReference],
                        completion: completion)
    }
    
    func verifyInvestmentTransaction(investmentReference: String,
                                     completion: @escaping (VerifyInvestmentTransactionResponse?) -> Void) {
        
        Network.shared.request(ApiEndPoints.verifyInvestmentTransaction(),
                        method: .post,
                        parameters: [ApiConstants.Reference: investmentReference],
                        completion: completion)
    }
    
    func proofOfInvestment() {
        
    }
    
    func updateProfile(dob: String?,
                       fullname: String?,
                       phone: String?,
                       title: String?,
                       completion: @escaping (ProfileUpdateResponse?) -> Void) {
        
        var parameters: [String:String] = [:]
        
        if let dob = dob {
            parameters[ApiConstants.Dob] = dob
        }
        
        if let fullname = fullname {
            parameters[ApiConstants.FullName] = fullname
        }
        
        if let phone = phone {
            parameters[ApiConstants.Phone] = phone
        }
        
        if let title = title {
            parameters[ApiConstants.Title] = title
        }
        
        Network.shared.request(ApiEndPoints.updateProfile(),
                        method: .post,
                        parameters: parameters,
                        completion: completion)
    }
}
