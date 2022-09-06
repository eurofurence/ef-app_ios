import Foundation

public struct FirebaseRemoteConfiguration: RemoteConfiguration {
    
    public static var shared: FirebaseRemoteConfiguration = {
        return FirebaseRemoteConfiguration(firebaseConfiguration: StaticNarrowedFirebaseConfiguration.shared)
    }()
    
    private let firebaseConfiguration: NarrowedFirebaseConfiguration
    
    init(firebaseConfiguration: NarrowedFirebaseConfiguration) {
        self.firebaseConfiguration = firebaseConfiguration
    }
    
    func prepareConfiguration() async {
        await firebaseConfiguration.acquireRemoteValues()
    }
    
    public let onChange = RemoteConfigurationChangedPublisher()
    
    public subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
        guard let wellDefinedType = Key.self as? WellDefinedFirebaseRemoteConfiguredValue.Type else { return nil }
        
        let firebaseKey = wellDefinedType.firebaseKey
        guard let remotelyConfiguredValue = firebaseConfiguration.remotelyConfiguredValue(forKey: firebaseKey) else {
            return nil
        }
        
        return wellDefinedType.convert(value: remotelyConfiguredValue) as? Key.Value
    }
    
}

// MARK: - Well Defined Firebase Configured Values

private protocol WellDefinedFirebaseRemoteConfiguredValue {
    
    static var firebaseKey: String { get }
    
    static func convert(value: NarrowedFirebaseConfiguredValue) -> Any?
    
}

extension RemoteConfigurationKeys.ConventionStartTime: WellDefinedFirebaseRemoteConfiguredValue {
    
    static var firebaseKey: String {
        "nextConStart"
    }
    
    static func convert(value: NarrowedFirebaseConfiguredValue) -> Any? {
        let number = value.numberValue
        return Date(timeIntervalSince1970: number.doubleValue)
    }
    
}
