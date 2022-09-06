import CoreData
import EurofurenceWebAPI
import Logging

class UpdateLocalMessagesOperation {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "UpdateMessages")
    
    init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    func execute() async throws {
        if let credential = configuration.keychain.credential {
            if credential.tokenExpiryDate > Date() {
                try await fetchMessages(authenticationToken: credential.authenticationToken)
            }
        }
    }
    
    private func fetchMessages(authenticationToken: AuthenticationToken) async throws {
        do {
            let messages = try await configuration.api.fetchMessages(for: authenticationToken)
            
            let writingContext = configuration.persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { [writingContext] in
                for message in messages {
                    let entity = try Message.message(for: message.id, in: writingContext)
                    entity.update(from: message)
                }
                
                try writingContext.save()
            }
        } catch {
            logger.error("Failed to fetch messages.", metadata: ["Error": .string(String(describing: error))])
            throw error
        }
    }
    
}
