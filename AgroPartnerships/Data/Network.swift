import Foundation
import Alamofire
import EVReflection

public class Network {
    
    static func getDefaultHeaders() -> HTTPHeaders {
        var headers = ["Content-Type": "application/json"]
        
        if let token = LocalStorage.shared.getAccessToken() {
            headers[ApiConstants.Authorization] = "Bearer \(token)"
        }
        
        return headers
    }
    
    private static func getFinalHeaders(_ headers: HTTPHeaders) -> HTTPHeaders {
        var finalHeaders = getDefaultHeaders()
        for (key, value) in headers {
            finalHeaders[key] = value
        }
        return finalHeaders
    }
    
    public static func request<T: NSObject>(_ url: String!,
                                            method: HTTPMethod! = .get,
                                            parameters: Parameters = [:],
                                            headers: HTTPHeaders = [:],
                                            completion: @escaping (_ response: T?) -> Void) where T: EVReflectable {
        
        Alamofire.request(url, method: method, parameters: parameters, headers: getFinalHeaders(headers))
            .debugLog()
            .responseObject {(response: DataResponse<T>) in
                
                switch response.result {
                case .success:
                    if let data = response.result.value {
                        completion(data)
                    } else {
                        completion(nil);
                    }
                    
                case .failure(let error):
                    AgroLogger.log(error)
                    completion(nil);
                }
        }
    }
}
