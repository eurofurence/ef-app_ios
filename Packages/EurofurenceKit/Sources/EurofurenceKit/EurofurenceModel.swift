import Combine
import CoreData
import EurofurenceWebAPI
import Foundation
import Logging

/// Root entry point for entity access, authentication, and more within the Eurofurence targets.
public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "EurofurenceModel")
    private var pushNotificationDeviceTokenData: Data?
    private var subscriptions = Set<AnyCancellable>()
    
    /// The current synchronisation phase between the model and the backing store.
    @Published public internal(set) var cloudStatus: CloudStatus = .idle
    
    /// The currently authenticated user within the model, or `nil` if the model is unauthenticated.
    @Published public private(set) var currentUser: User?
    
    /// Designates the start time of the next convention, or `nil` if the start time is not known.
    @Published public private(set) var conventionStartTime: Date?
    
    /// A read-only managed object context for use in presenting the state of the model to the user.
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public convenience init() {
        self.init(configuration: Configuration())
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    /// Prepares the model for display within an application. Must be called at least once after the application has
    /// launched.
    public func prepareForPresentation() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [self] in
                await updateAuthenticatedStateFromPersistentCredential()
            }
            
            group.addTask { [self] in
                await acquireRemoteConfiguration()
            }
            
            await group.waitForAll()
        }
    }
    
    /// Attempts to synchronise the model with the backing store.
    public func updateLocalStore() async throws {
        do {
            try await performLocalStoreUpdates()
            cloudStatus = .updated
        } catch {
            cloudStatus = .failed
            throw error
        }
    }
    
    private func performLocalStoreUpdates() async throws {
        let context = prepareUpdateOperationContext()
        let operation = UpdateLocalStoreOperation()
        cloudStatus = .updating(progress: operation.progress)
        
        // Simultaneously update the local store and perform any local book-keeping.
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await operation.execute(context: context)
            }
            
            group.addTask { [self] in
                await updateAuthenticatedStateFromPersistentCredential()
            }
            
            try await group.waitForAll()
        }
    }
    
    private func prepareUpdateOperationContext() -> UpdateOperationContext {
        let writingContext = configuration.persistentContainer.newBackgroundContext()
        
        return UpdateOperationContext(
            managedObjectContext: writingContext,
            keychain: configuration.keychain,
            api: configuration.api,
            properties: configuration.properties,
            conventionIdentifier: configuration.conventionIdentifier
        )
    }
    
}

// MARK: - Remote Configuration

extension EurofurenceModel {
    
    private func acquireRemoteConfiguration() async {
        let remoteConfiguration = await configuration.api.fetchRemoteConfiguration()
        prepareForReading(from: remoteConfiguration)
    }
    
    private func prepareForReading(from remoteConfiguration: RemoteConfiguration) {
        remoteConfiguration
            .onChange
            .sink { [self] remoteConfiguration in
                read(remoteConfiguration: remoteConfiguration)
        }
        .store(in: &subscriptions)

        read(remoteConfiguration: remoteConfiguration)
    }
    
    private func read(remoteConfiguration: RemoteConfiguration) {
        let conventionStartTime = remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self]
        
        if conventionStartTime != self.conventionStartTime {
            self.conventionStartTime = conventionStartTime
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
            currentUser = User(authenticatedUser: authenticatedUser)
            
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [self] in
                    await registerPushNotificationToken(against: authenticatedUser)
                }
                
                group.addTask { [self] in
                    await updateLocalMessagesCache()
                }
                
                await group.waitForAll()
            }
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
        
        await updateLocalMessagesCache()
    }
    
    private func registerPushNotificationToken(against authenticatedUser: AuthenticatedUser) async {
        if let pushNotificationDeviceTokenData = pushNotificationDeviceTokenData {
            await associateDevicePushNotificationToken(
                data: pushNotificationDeviceTokenData,
                withUserAuthenticationToken: authenticatedUser.token
            )
        }
    }
    
    private func updateLocalMessagesCache() async {
        do {
            let context = prepareUpdateOperationContext()
            let updateMessages = UpdateLocalMessagesOperation()
            try await updateMessages.execute(context: context)
        } catch {
            logger.info(
                "Failed to update local messages. App may appear in an inconsistent state until next refresh."
            )
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
            if credential.isValid {
                currentUser = User(credential: credential)
            } else {
                await automaticallySignOutUser()
            }
        }
    }
    
    private func automaticallySignOutUser() async {
        do {
            try await signOut()
        } catch {
            logger.error(
                "Failed to automatically sign out user.",
                metadata: ["Error": .string(String(describing: error))]
            )
        }
    }
    
}
