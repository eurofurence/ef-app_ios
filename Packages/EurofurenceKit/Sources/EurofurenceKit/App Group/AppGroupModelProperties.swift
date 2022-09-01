import EurofurenceWebAPI
import Foundation

public class AppGroupModelProperties: EurofurenceModelProperties {
    
    public static let shared = AppGroupModelProperties()
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults(suiteName: SecurityGroup.identifier)!
    }
    
    public var synchronizationChangeToken: SynchronizationPayload.GenerationToken?
    
}
