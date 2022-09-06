import CoreData
import EurofurenceWebAPI
import Foundation
import Logging

/// Root entry point for entity access, authentication, and more within the Eurofurence targets.
public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "EurofurenceModel")
    private var pushNotificationDeviceTokenData: Data?
    
    /// The current synchronisation phase between the model and the backing store.
    @Published public private(set) var cloudStatus: CloudStatus = .idle
    
    /// The currently authenticated user within the model, or `nil` if the model is unauthenticated.
    @Published public private(set) var currentUser: User?
    
    /// A read-only managed object context for use in presenting the state of the model to the user.
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public convenience init() {
        self.init(configuration: Configuration())
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
        registerForEntityNotifications()
    }
    
    /// Prepares the model for display within an application. Must be called at least once after the application has
    /// launched.
    public func prepareForPresentation() async {
        await updateAuthenticatedStateFromPersistentCredential()
    }
    
    /// Attempts to synchronise the model with the backing store.
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
    
    /// Represents a collection of configurable attributes the model should use during runtime.
    public struct Configuration {
        
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
    
    /// Represents a phase of synchronisation status as the model fetches updates from the backing store.
    public enum CloudStatus: Equatable {
        
        /// The model is not processing any changes.
        case idle
        
        /// The model is currently synchronising with the backing store.
        case updating(progress: EurofurenceModel.Progress)
        
        /// The model has completed synchronising with the backing store.
        case updated
        
        /// The model attempted to synchronise with the backing store, but encountered an error.
        case failed
    }
    
    /// Represents the relative progress made by the model during a synchronisation pass with the remote store.
    public class Progress: ObservableObject, Equatable {
        
        public static func == (lhs: EurofurenceModel.Progress, rhs: EurofurenceModel.Progress) -> Bool {
            lhs === rhs
        }
        
        private let progress = Foundation.Progress()
        private var progressObservation: NSObjectProtocol?
        private var localizedDescriptionObservation: NSObjectProtocol?
        
        /// A number between 0.0 and 1.0 that represents the overall completeness of the current synchronisation pass,
        /// where 0 represents not started and 1 represents completed. The absence of a value indicates the overall
        /// progress cannot yet be determined.
        @Published public private(set) var fractionComplete: Double?
        
        /// A short, localized description that may be presented to the user as the synchronisation pass continues.
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

extension EurofurenceModel {
    
    /// Registers the Apple Push Notification Service (APNS) token of the current device with the model.
    ///
    /// Depending on the user's authentication status, they may begin to receive personalised pushes following the
    /// registration of the device push token. Any user who grants push access will still receive non-personalised
    /// pushes.
    ///
    /// - Parameter data: The token data generated by the device for use in publishing remote notifications to this
    ///                   device via APNS.
    public func registerRemoteNotificationDeviceTokenData(_ data: Data) async {
        pushNotificationDeviceTokenData = data
        
        let credential = configuration.keychain.credential
        await associateDevicePushNotificationToken(
            data: data,
            withUserAuthenticationToken: credential?.authenticationToken
        )
    }
    
    /// Attempts to sign into the application using the provided `Login`.
    ///
    /// - Parameter login: The credentials to use when logging in. An improperly configured set of credentials performs
    ///                    a no-op.
    public func signIn(with login: Login) async throws {
        guard let loginRequest = login.request else { return }
        
        do {
            let authenticatedUser = try await configuration.api.requestAuthenticationToken(using: loginRequest)
            storeAuthenticatedUserIntoKeychain(authenticatedUser)
            
            if let pushNotificationDeviceTokenData = pushNotificationDeviceTokenData {
                await associateDevicePushNotificationToken(
                    data: pushNotificationDeviceTokenData,
                    withUserAuthenticationToken: authenticatedUser.token
                )
            }
            
            currentUser = User(registrationNumber: authenticatedUser.userIdentifier, name: authenticatedUser.username)
            
            let updateMessages = UpdateLocalMessagesOperation(configuration: configuration)
            await updateMessages.execute()
        } catch {
            logger.error("Failed to authenticate user.", metadata: ["Error": .string(String(describing: error))])
            throw EurofurenceError.loginFailed
        }
    }
    
    /// Attempts to sign out of the application.
    ///
    /// Attempting to sign out when not already signed in is a no-op.
    public func signOut() async throws {
        guard let credential = configuration.keychain.credential else { return }
        
        let logout = LogoutRequest(
            authenticationToken: credential.authenticationToken,
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        try await configuration.api.requestLogout(logout)
        
        configuration.keychain.credential = nil
        currentUser = nil
        
        await deleteMessagesFromPersistentStore()
    }
    
    private func deleteMessagesFromPersistentStore() async {
        do {
            let writingContext = configuration.persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { [writingContext] in
                let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
                fetchRequest.predicate = NSPredicate(value: true)
                
                let messages = try writingContext.fetch(fetchRequest)
                for message in messages {
                    writingContext.delete(message)
                }
                
                try writingContext.save()
            }
        } catch {
            logger.error("Failed to delete local messages.", metadata: ["Error": .string(String(describing: error))])
        }
    }
    
    private func associateDevicePushNotificationToken(
        data: Data,
        withUserAuthenticationToken token: AuthenticationToken?
    ) async {
        let pushNotificationDeviceRegistration = RegisterPushNotificationDeviceToken(
            authenticationToken: token,
            pushNotificationDeviceToken: data
        )
        
        do {
            try await configuration.api.registerPushNotificationToken(registration: pushNotificationDeviceRegistration)
        } catch {
            logger.error(
                "Failed to register remote notification token.",
                metadata: ["Error": .string(String(describing: error))]
            )
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
    
    private func updateAuthenticatedStateFromPersistentCredential() async {
        if let credential = configuration.keychain.credential {
            if credential.tokenExpiryDate > Date() {
                currentUser = User(registrationNumber: credential.registrationNumber, name: credential.username)
            } else {
                await automaticallySignOutUser()
            }
        }
    }
    
    private func automaticallySignOutUser() async {
        do {
            try await signOut()
        } catch {
            logger.error("Failed to automatically sign out user.", metadata: ["Error": .string(String(describing: error))])
        }
    }
    
}
        
// MARK: - Fetching Entities

extension EurofurenceModel {
    
    /// Fetches the `Announcement` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the announcement to be fetched.
    /// - Returns: The `Announcement` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidAnnouncement` if no `Announcement` is associated with the given identifier.
    public func announcement(identifiedBy identifier: String) throws -> Announcement {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidAnnouncement(identifier))
    }
    
    /// Fetches the `Event` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the event to be fetched.
    /// - Returns: The `Event` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidEvent` if no `Event` is associated with the given identifier.
    public func event(identifiedBy identifier: String) throws -> Event {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidEvent(identifier))
    }
    
    /// Fetches the `Dealer` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the dealer to be fetched.
    /// - Returns: The `Dealer` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidDealer` if no `Dealer` is associated with the given identifier.
    public func dealer(identifiedBy identifier: String) throws -> Dealer {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidDealer(identifier))
    }
    
    /// Fetches the `Message` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the message to be fetched.
    /// - Returns: The `Message` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidMessage` if no `Message` is associated with the given identifier.
    public func message(identifiedBy identifier: String) throws -> Message {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let fetchResults = try viewContext.fetch(fetchRequest)
        if let message = fetchResults.first {
            return message
        } else {   
            throw EurofurenceError.invalidMessage(identifier)
        }
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
