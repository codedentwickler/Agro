import Foundation

struct ApiEndPoints {
    
    static func login() -> String {
        return "\(ApiConstants.BaseUrl)/user/signin"
    }
    
    static func signUp() -> String {
        return "\(ApiConstants.BaseUrl)/user/signup"
    }
    
    static func forgotPassword() -> String {
        return "\(ApiConstants.BaseUrl)/user/reset"
    }
    
    static func getAvailableCommodities(limitToNumber limit: Int) -> String {
        return "\(ApiConstants.BaseUrl)/investments/recent?limit=\(limit)"
    }
    
    static func dashboardInformation() -> String {
        return "\(ApiConstants.BaseUrl)/user/dashboard"
    }
    
    static func initializeInvestment() -> String {
        return "\(ApiConstants.BaseUrl)/user/invest"
    }
    
    static func rollbackInvestment() -> String {
        return "\(ApiConstants.BaseUrl)/user/invest/rollback"
    }
    
    static func verifyInvestmentTransaction() -> String {
        return "\(ApiConstants.BaseUrl)/user/invest/verify/transaction"
    }
    
    static func proofOfInvestment() -> String {
        return "\(ApiConstants.BaseUrl)/invest/proof"
    }
    
    static func updateProfile() -> String {
        return "\(ApiConstants.BaseUrl)/user/profile"
    }
    
    static func cards() -> String {
        return "\(ApiConstants.BaseUrl)/user/card-authorization"
    }
    
    static func helpdesk() -> String {
        return "\(ApiConstants.BaseUrl)/help-desk"
    }
    
    static func changePassword() -> String {
        return "\(ApiConstants.BaseUrl)/user/password/change"
    }
    
    static func updateUserBank() -> String {
        return "\(ApiConstants.BaseUrl)/user/bank"
    }
    
    static func fundWallet() -> String {
        return "\(ApiConstants.BaseUrl)/user/wallet/fund"
    }
    
    static func verifyWalletPayment() -> String {
        return "\(ApiConstants.BaseUrl)/user/wallet/fund/verify"
    }
    
    static func payout() -> String {
        return "\(ApiConstants.BaseUrl)/user/payout"
    }
}
