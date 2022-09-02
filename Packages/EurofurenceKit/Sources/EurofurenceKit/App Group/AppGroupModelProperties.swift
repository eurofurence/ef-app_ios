import EurofurenceWebAPI
import Foundation

public class AppGroupModelProperties: EurofurenceModelProperties {
    
    public static let shared = AppGroupModelProperties()
    private let userDefaults: UserDefaults
    
    convenience init() {
        guard let appGroupUserDefaults = UserDefaults(suiteName: SecurityGroup.identifier) else {
            fatalError("Cannot instantiate App Group user defaults")
        }
        
        self.init(userDefaults: appGroupUserDefaults)
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    private struct Keys {
        static let synchronizationGenerationTokenData = "EFKSynchronizationGenerationTokenData"
    }
    
    public var synchronizationChangeToken: SynchronizationPayload.GenerationToken? {
        get {
            guard let data = userDefaults.data(forKey: Keys.synchronizationGenerationTokenData) else { return nil }
            
            let decoder = JSONDecoder()
            return try? decoder.decode(SynchronizationPayload.GenerationToken.self, from: data)
        }
        set {
            if let newValue = newValue {
                let encoder = JSONEncoder()
                guard let data = try? encoder.encode(newValue) else { return }
                
                userDefaults.set(data, forKey: Keys.synchronizationGenerationTokenData)
            } else {
                userDefaults.set(nil, forKey: Keys.synchronizationGenerationTokenData)
            }
        }
    }
    
}
