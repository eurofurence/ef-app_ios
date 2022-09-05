import CoreData
import EurofurenceWebAPI
import Logging

class UpdateLocalMessagesOperation {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "UpdateMessages")
    
    init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    func execute() async {
        if let authenticationToken = configuration.keychain.credential?.authenticationToken {
            await fetchMessages(authenticationToken: authenticationToken)
        }
    }
    
    private func fetchMessages(authenticationToken: AuthenticationToken) async {
        do {
            let messages = try await configuration.api.fetchMessages(for: authenticationToken)
            
            let writingContext = configuration.persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { [writingContext] in
                for message in messages {
                    let entity = Message(context: writingContext)
                    entity.update(from: message)
                }
                
                try writingContext.save()
            }
        } catch {
            logger.error("Failed to fetch messages.", metadata: ["Error": .string(String(describing: error))])
        }
    }
    
}
