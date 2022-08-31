import Foundation

public class AppGroupModelProperties: EurofurenceModelProperties {
    
    public static let shared = AppGroupModelProperties()
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults(suiteName: SecurityGroup.identifier)!
    }
    
    public var lastSyncTime: Date? {
        get {
            userDefaults.object(forKey: "") as? Date
        }
        set {
            userDefaults.set(newValue, forKey: "")
        }
    }
    
}
