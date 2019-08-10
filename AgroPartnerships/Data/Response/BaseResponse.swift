

import EVReflection

public class BaseResponse: EVNetworkingObject {
    public var status: String!
    public var message: String!
    
    override public func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        
        if key == "status" {
            status = value as? String
        }
    }
    
    public func isSuccessful() -> Bool {
        return status == "success"
    }
}
