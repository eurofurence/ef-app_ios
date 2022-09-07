import EurofurenceWebAPI

extension EurofurenceModel {
    
    /// Represents a collection of configurable attributes the model should use during runtime.
    public struct Configuration {
        
        let persistentContainer: EurofurencePersistentContainer
        let properties: EurofurenceModelProperties
        let keychain: Keychain
        let api: EurofurenceAPI
        let conventionIdentifier: ConventionIdentifier
        
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
            conventionIdentifier: ConventionIdentifier = .current
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
                conventionIdentifier: conventionIdentifier
            )
        }
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            keychain: Keychain = SecKeychain.shared,
            api: EurofurenceAPI,
            conventionIdentifier: ConventionIdentifier = .current
        ) {
            self.persistentContainer = EurofurencePersistentContainer(
                api: api,
                keychain: keychain,
                properties: properties
            )
            
            self.properties = properties
            self.keychain = keychain
            self.api = api
            self.conventionIdentifier = conventionIdentifier
            
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
