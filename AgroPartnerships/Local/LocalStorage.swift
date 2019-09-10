import Foundation
import SwiftyJSON

final class LocalStorage: NSObject {
    
    override init() {
        super.init()
    }
    
    static let shared = LocalStorage()
    
    var countryCodeJSON : [JSON]!
    
    public func persistString(string: String!, key: String){
        delete(key: key);
        UserDefaults.standard.setValue(string, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func persistDictionary(dictionary: [String: AnyObject], key: String) {
        delete(key: key)
        UserDefaults.standard.set(dictionary, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func persistData(encodedData: Data!, key: String) {
        delete(key: key)

        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func persistStruct(encodedData: Codable!, key: String) {
        delete(key: key)
        
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func persistInt(value: Int!, key: String){
        delete(key: key);
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func persistDouble(value: Double!, key: String){
        delete(key: key);
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func getString(key: String) -> String? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    public func getDictionary(key: String) -> [String: AnyObject]? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? [String:AnyObject]
    }
    
    public func getData(key: String) -> Data? {
        
        UserDefaults.standard.synchronize()
        if let data = UserDefaults.standard.data(forKey: key) {
            return data
        } else {
            return nil
        }
    }
    
    public func contains(key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    public func getInt(key: String) -> Int {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public func getDouble(key: String) -> Double {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.double(forKey: key)
    }
    
    public func delete(key: String){
        UserDefaults.standard.removeObject(forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func delete(keys: String...){
        keys.forEach({delete(key: $0)})
    }

    public func clearAll(){
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
    
    public func currentUser() -> CurrentUser? {
        if let data = LocalStorage.shared.getData(key: PersistenceIDs.User)  {
            do {
                let usr = try JSONDecoder().decode(CurrentUser.self, from: data)
                return usr
            }
            catch {
                AgroLogger.log(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    public func getAccessToken() -> String? {
        return self.getString(key: PersistenceIDs.AccessToken)
    }

    func loadCountryCodesJSON(finishedClosure:@escaping ((_ jsonObject: [JSON]?,_ error: NSError?) ->Void)) {
        
        guard let json = self.countryCodeJSON else{
            finishedClosure(nil, NSError(domain: "can convert to data", code: 999, userInfo: nil))
            return
        }
        
        finishedClosure(json, nil)
    }
    
    func loadCountryCodesJSON() {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: "country_code", ofType: "json") else {
                AgroLogger.log(NSError(domain: "JSON file don't founded", code: 998, userInfo: nil))
                return
            }
            //Load file data part
            guard let jsonData = (try? Data(contentsOf: URL(fileURLWithPath: path))) else{
                AgroLogger.log(NSError(domain: "can convert to data", code: 999, userInfo: nil))
                return
            }
            
            do {
                let json = try JSON(data: jsonData)
                    DispatchQueue.main.async {
                        self.countryCodeJSON = json.arrayValue
                    }
            } catch let error as NSError {
                AgroLogger.log(error)
            }
        }
    }
}
