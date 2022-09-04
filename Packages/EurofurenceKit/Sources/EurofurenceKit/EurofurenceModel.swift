import CoreData
import EurofurenceWebAPI
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "EurofurenceModel")
    private var pushNotificationDeviceTokenData: Data?
    
    @Published public private(set) var cloudStatus: CloudStatus = .idle
    @Published public private(set) var currentUser: User?
    
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
        
        if let credential = configuration.keychain.credential {
            currentUser = User(name: credential.username, registrationNumber: credential.registrationNumber)
        }
        
        registerForEntityNotifications()
    }
    
    public func updateLocalStore() async throws {
        let operation = UpdateLocalStoreOperation(configuration: configuration)
        cloudStatus = .updating(progress: operation.progress)
        
        do {
            try await operation.execute()
            cloudStatus = .updated
        } catch {
            cloudStatus = .failed
            throw error
        }
    }
    
}

// MARK: - Model Configuration

extension EurofurenceModel {
    
    public struct Configuration {
        
        public enum Environment {
            
            case persistent
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
        
        let persistentContainer: EurofurencePersistentContainer
        let properties: EurofurenceModelProperties
        let keychain: Keychain
        let api: EurofurenceAPI
        let conventionIdentifier: ConventionIdentifier
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            keychain: Keychain = SecKeychain.shared,
            api: EurofurenceAPI = CIDSensitiveEurofurenceAPI.api(),
            conventionIdentifier: ConventionIdentifier = .current
        ) {
            self.persistentContainer = EurofurencePersistentContainer()
            self.properties = properties
            self.keychain = keychain
            self.api = api
            self.conventionIdentifier = conventionIdentifier
            
            environment.configure(persistentContainer: persistentContainer, properties: properties)
        }
        
    }
    
}

// MARK: - Cloud Status

extension EurofurenceModel {
    
    public enum CloudStatus: Equatable {
        case idle
        case updating(progress: EurofurenceModel.Progress)
        case updated
        case failed
    }
    
    public class Progress: ObservableObject, Equatable {
        
        public static func == (lhs: EurofurenceModel.Progress, rhs: EurofurenceModel.Progress) -> Bool {
            lhs === rhs
        }
        
        private let progress = Foundation.Progress()
        private var progressObservation: NSObjectProtocol?
        private var localizedDescriptionObservation: NSObjectProtocol?
        
        @Published public private(set) var fractionComplete: Double?
        
        public var localizedDescription: String {
            progress.localizedDescription
        }
        
        init() {
            progress.totalUnitCount = 0
            progress.completedUnitCount = 0
            
            progressObservation = progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                self?.fractionComplete = progress.fractionCompleted
            }
        }
        
        func update(totalUnitCount: Int) {
            progress.totalUnitCount = Int64(totalUnitCount)
        }
        
        func updateCompletedUnitCount() {
            progress.completedUnitCount += 1
        }
        
    }
    
}

// MARK: - Authentication

public struct LoginParameters {
    
    public var registrationNumber: Int
    public var username: String
    public var password: String
    
    public init(registrationNumber: Int, username: String, password: String) {
        self.registrationNumber = registrationNumber
        self.username = username
        self.password = password
    }
    
}

extension EurofurenceModel {
    
    public struct User {
        
        public var name: String
        public var registrationNumber: Int
        
    }
    
    /// Registers the Apple Push Notification Service (APNS) token of the current device with the model.
    ///
    /// If the user is already logged in, the token is immediatley associated (or re-associated) with their account.
    ///
    /// - Parameter data: The token data generated by the device for use in publishing remote notifications to this
    ///                   device via APNS.
    public func registerRemoteNotificationDeviceTokenData(_ data: Data) async {
        pushNotificationDeviceTokenData = data
        
        if let credential = configuration.keychain.credential {
            await associateDevicePushNotificationToken(
                data: data,
                withUserAuthenticationToken: credential.authenticationToken
            )
        }
    }
    
    public func signIn(with login: LoginParameters) async throws {
        let loginRequest = Login(
            registrationNumber: login.registrationNumber,
            username: login.username,
            password: login.password
        )
        
        do {
            let authenticatedUser = try await configuration.api.requestAuthenticationToken(using: loginRequest)
            storeAuthenticatedUserIntoKeychain(authenticatedUser)
            
            if let pushNotificationDeviceTokenData = pushNotificationDeviceTokenData {
                await associateDevicePushNotificationToken(
                    data: pushNotificationDeviceTokenData,
                    withUserAuthenticationToken: authenticatedUser.token
                )
            }
            
            currentUser = User(name: authenticatedUser.username, registrationNumber: authenticatedUser.userIdentifier)
        } catch {
            throw EurofurenceError.loginFailed
        }
    }
    
    public func signOut() async throws {
        guard let credential = configuration.keychain.credential else { return }
        
        let logout = Logout(
            authenticationToken: credential.authenticationToken,
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        try await configuration.api.requestLogout(logout)
        
        configuration.keychain.credential = nil
        currentUser = nil
    }
    
    private func associateDevicePushNotificationToken(data: Data, withUserAuthenticationToken token: String) async {
        let pushNotificationDeviceRegistration = PushNotificationDeviceRegistration(
            authenticationToken: token,
            pushNotificationDeviceToken: data
        )
        
        do {
            try await configuration.api.registerPushNotificationToken(registration: pushNotificationDeviceRegistration)
        } catch {
            
        }
    }
    
    private func storeAuthenticatedUserIntoKeychain(_ authenticatedUser: AuthenticatedUser) {
        let credential = Credential(
            username: authenticatedUser.username,
            registrationNumber: authenticatedUser.userIdentifier,
            authenticationToken: authenticatedUser.token,
            tokenExpiryDate: authenticatedUser.tokenExpires
        )
        
        configuration.keychain.credential = credential
    }
    
}
        
// MARK: - Fetching Entities

extension EurofurenceModel {
    
    public func announcement(identifiedBy identifier: String) throws -> Announcement {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidAnnouncement(identifier))
    }
    
    public func event(identifiedBy identifier: String) throws -> Event {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidEvent(identifier))
    }
    
    public func dealer(identifiedBy identifier: String) throws -> Dealer {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidDealer(identifier))
    }
    
    private func entity<E>(
        identifiedBy identifier: String,
        throwWhenMissing: @autoclosure () -> EurofurenceError
    ) throws -> E where E: Entity {
        let fetchRequest: NSFetchRequest<E> = E.fetchRequestForExistingEntity(identifier: identifier)
        
        let results = try viewContext.fetch(fetchRequest)
        if let entity = results.first {
            return entity
        } else {
            throw throwWhenMissing()
        }
    }
    
}

// MARK: - Processing Entity Notifications

extension EurofurenceModel {
    
    private func registerForEntityNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(willDeleteImage(_:)),
            name: .EFKWillDeleteImage,
            object: nil
        )
    }
    
    @objc private func willDeleteImage(_ notification: Notification) {
        guard let image = notification.object as? Image else { return }
        guard let imageURL = image.cachedImageURL else { return }
        
        do {
            logger.info("Deleting image", metadata: ["ID": .string(image.identifier)])
            try configuration.properties.removeContainerResource(at: imageURL)
        } catch {
            let metadata: Logger.Metadata = [
                "ID": .string(image.identifier),
                "Error": .string(String(describing: error))
            ]
            
            logger.error("Failed to delete image.", metadata: metadata)
        }
    }
    
}
