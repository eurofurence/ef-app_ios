import FirebaseRemoteConfig
import Logging

struct StaticNarrowedFirebaseConfiguration: NarrowedFirebaseConfiguration {
    
    static let shared = StaticNarrowedFirebaseConfiguration()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let logger = Logger(label: "FirebaseRemoteConfig")
    
    private init() {
        
    }
    
    func acquireRemoteValues() async {
        do {
            try await remoteConfig.activate()
        } catch {
            logger.error(
                "Failed to activate Firebase Remote Config.",
                metadata: ["Error": .string(String(describing: error))]
            )
        }
    }
    
    func remotelyConfiguredValue(forKey key: String) -> NarrowedFirebaseConfiguredValue? {
        let remoteValue = remoteConfig.configValue(forKey: key)
        return FirebaseValue(remoteValue: remoteValue)
    }
    
    private struct FirebaseValue: NarrowedFirebaseConfiguredValue {
        
        var remoteValue: FirebaseRemoteConfig.RemoteConfigValue
        
        var numberValue: NSNumber {
            remoteValue.numberValue
        }
        
    }
    
}
