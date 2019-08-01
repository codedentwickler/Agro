

import Foundation
import EVReflection

public class LoginResponse: EVNetworkingObject {
    public var token: String!
    public var status: Bool!
    public var data: User!
    public var message: String!
    
    override public func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        
        if key == "status" {
            status = value as? Bool
        }
    }

}

public class User: EVNetworkingObject {
    public var _id: String!
    public var first_name: String!
    public var last_name: String!
    public var Email: String!
    public var Phone: String!
    public var Id: String!
    public var rte_status: NSNumber!
    public var access: NSNumber!
    public var status: NSNumber!
    public var profile_photo: String!
    public var wallet: NSNumber!
    public var Address: String!
    public var gender: String!
}
