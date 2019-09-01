import Foundation
import Alamofire
import EVReflection
import SwiftyJSON

public class Network {
    var manager: SessionManager?
    
    public static let shared = Network()
    
    init() {
        let configuration = URLSessionConfiguration.default
        //        configuration.httpAdditionalHeaders = ourHeaders
        // disable default credential store
        configuration.urlCredentialStorage = nil
    
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func getDefaultHeaders() -> HTTPHeaders {
        var headers = ["Content-Type": "application/json"]

        if let token = LocalStorage.shared.getAccessToken() {
            headers[ApiConstants.Authorization] = "Bearer \(token)"
        }
        
        return headers
    }
    
    private func getFinalHeaders(_ headers: HTTPHeaders) -> HTTPHeaders {
        var finalHeaders = getDefaultHeaders()
        for (key, value) in headers {
            finalHeaders[key] = value
        }
        return finalHeaders
    }
    
    public func request<T: NSObject>(_ urlString: String,
                                     method: HTTPMethod = .get,
                                     parameters: Parameters = [:],
                                     headers: HTTPHeaders = [:],
                                     completion: @escaping (_ response: T?) -> Void) where T: EVReflectable {
        
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        manager?.request(URL(string: url)!,
                         method: method,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: getFinalHeaders(headers))
            .debugLog()
            .responseObject {(response: DataResponse<T>) in
                AgroLogger.log("\(response)")

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
    
    public func request(_ urlString: String,
                               method: HTTPMethod = .get,
                               parameters: Parameters = [:],
                               headers: HTTPHeaders = [:],
                               completion: @escaping (_ response: JSON?) -> Void) {
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        manager?.request(URL(string: url)!,
                         method: method,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: getFinalHeaders(headers))
            .debugLog()
            .responseJSON { (response) in
                AgroLogger.log("\(response)")
                
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        completion(json)
                    case .failure(let error):
                        completion(nil)
                        AgroLogger.log(error)
                }
        }
    }
}
