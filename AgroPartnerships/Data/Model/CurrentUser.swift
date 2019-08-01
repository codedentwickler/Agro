
import Foundation

struct CurrentUser: Codable {
    public var firstName: String
    public var lastName: String
    public var email: String
    public var phone: String
    public var id: String
    public var timeStamp: Double
    public var token: String
    public var photoName: String?
    public var address: String?
    public var gender: String?
    
    public var fullname : String {
        return String(format: "%@ %@", firstName, lastName)
    }
}
