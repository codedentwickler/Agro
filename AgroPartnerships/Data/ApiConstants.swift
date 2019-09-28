import Foundation

struct ApiConstants {
    
    public static let BaseUrl = "https://staging.agropartnerships.co" // "http://23.239.14.141"
   
    public static let ImageBaseUrl = BaseUrl + "/img/"
    public static let PaystackPublicKey = "pk_test_29fb86813b279682ccf49baa572ebabe9d6fd248"
    
    // Keys
    public static let Authorization = "Authorization"
    public static let Bank = "bank"
    public static let Title = "title"
    public static let FullName = "fullname"
    public static let Password = "password"
    public static let Referral = "referral"
    public static let Phone = "phone"
    public static let Email = "email"
    public static let No = "no"
    public static let Year = "year"
    public static let Month = "month"
    public static let Cvv = "cvv"
    
    public static let Item = "item"
    public static let Units = "units"
    public static let Price = "price"
    public static let PaymentMethod = "paymentMethod"
    public static let Credit = "credit"
    public static let AuthCode = "authCode"
    public static let Investment = "investment"
    public static let Reference = "reference"
    public static let Signature = "signature"

    public static let Amount = "amount"
    public static let Dob = "dob"
    public static let Token = "token"
    public static let Status = "status"
    public static let Active = "active"
    public static let Success = "success"
    public static let Pending = "pending"
    
    public static let Data = "data"
    public static let Validation = "validation"
    public static let ErrorType = "errorType"
    public static let Error = "error"

    static let Payout =                            "payout"
    static let PaymentInvestment =                 "payment-investment"
    static let FundWallet =                        "fund-wallet"
}
