

import EVReflection

class BaseResponse: EVNetworkingObject {
    public var token: String!
    public var status: Bool!
    public var message: String!
    
    override public func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        
        if key == "status" {
            status = value as? Bool
        }
    }
}
