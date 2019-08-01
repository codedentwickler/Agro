
import EVReflection

class SignUpResponse: EVNetworkingObject {
    public var token: String!
    public var status: Bool!
    public var data: SignUpUser!
    public var message: String!
    
    override public func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        
        if key == "status" {
            status = value as! Bool
        }
    }
}

class SignUpUser: EVNetworkingObject {
    
    public var first_name: String!
    public var last_name: String!
    public var Email: String!
    public var Phone: String!
    public var Id: String!
}
