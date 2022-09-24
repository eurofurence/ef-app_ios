import EurofurenceWebAPI

public struct UnimplementedEventCalendar: EventCalendar {
    
    public init() {
        
    }
    
    public let calendarChanged = EventCalendarChangedPublisher()
    
    public func add(entry: EventCalendarEntry) {
        
    }
    
    public func remove(entry: EventCalendarEntry) {
        
    }
    
    public func contains(entry: EventCalendarEntry) -> Bool {
        false
    }
    
}

extension EurofurenceModel {
    
    /// Represents a collection of configurable attributes the model should use during runtime.
    public struct Configuration {
        
        let persistentContainer: EurofurencePersistentContainer
        let properties: EurofurenceModelProperties
        let keychain: Keychain
        let api: EurofurenceAPI
        let conventionIdentifier: ConventionIdentifier
        let clock: Clock
        
        private static func versionedAPI(for conventionIdentifier: ConventionIdentifier) -> EurofurenceAPI {
            let configuration = CIDSensitiveEurofurenceAPI.Configuration(
                conventionIdentifier: conventionIdentifier.stringValue,
                hostVersion: "4.0.0"
            )
            
            return CIDSensitiveEurofurenceAPI(configuration: configuration)
        }
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            keychain: Keychain = SecKeychain.shared,
            calendar: EventCalendar = UnimplementedEventCalendar(),
            conventionIdentifier: ConventionIdentifier = .current,
            clock: Clock = DeviceSensitiveClock.shared
        ) {
            let apiConfiguration = CIDSensitiveEurofurenceAPI.Configuration(
                conventionIdentifier: conventionIdentifier.stringValue,
                hostVersion: "4.0.0"
            )
            
            let api = CIDSensitiveEurofurenceAPI(configuration: apiConfiguration)
            
            self.init(
                environment: environment,
                properties: properties,
                keychain: keychain,
                api: api,
                calendar: calendar,
                conventionIdentifier: conventionIdentifier
            )
        }
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            keychain: Keychain = SecKeychain.shared,
            api: EurofurenceAPI,
            calendar: EventCalendar,
            conventionIdentifier: ConventionIdentifier = .current,
            clock: Clock = DeviceSensitiveClock.shared
        ) {
            self.persistentContainer = EurofurencePersistentContainer(
                api: api,
                keychain: keychain,
                properties: properties,
                calendar: calendar
            )
            
            self.properties = properties
            self.keychain = keychain
            self.api = api
            self.conventionIdentifier = conventionIdentifier
            self.clock = clock
            
            environment.configure(persistentContainer: persistentContainer, properties: properties)
        }
        
    }
    
}

// MARK: - Environment

extension EurofurenceModel.Configuration {
    
    /// Designates the intended usage environment of the model.
    public enum Environment {
        
        /// The contents of the model should persist between lifecycles.
        case persistent
        
        /// The contents of the model should be discarded once the model has been deallocated.
        case memory
        
        fileprivate func configure(
            persistentContainer: EurofurencePersistentContainer,
            properties: EurofurenceModelProperties
        ) {
            switch self {
            case .persistent:
                persistentContainer.attachPersistentStore(properties: properties)
                
            case .memory:
                persistentContainer.attachMemoryStore()
            }
        }
        
    }
    
}
