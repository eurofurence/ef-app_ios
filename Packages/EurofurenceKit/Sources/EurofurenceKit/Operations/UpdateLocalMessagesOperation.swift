import CoreData
import EurofurenceWebAPI
import Logging

class UpdateLocalMessagesOperation: UpdateOperation {
    
    private let logger = Logger(label: "UpdateMessages")
    
    func execute(context: UpdateOperationContext) async throws {
        if let credential = context.keychain.credential, credential.isValid {
            try await fetchMessages(authenticationToken: credential.authenticationToken, context: context)
        } else {
            try await deleteLocalMessages(managedObjectContext: context.managedObjectContext)
        }
    }
    
    private func fetchMessages(
        authenticationToken: AuthenticationToken,
        context: UpdateOperationContext
    ) async throws {
        do {
            let messages = try await context.api.fetchMessages(for: authenticationToken)
            
            try await context.managedObjectContext.performAsync {
                for message in messages {
                    let entity = try Message.message(for: message.id, in: context.managedObjectContext)
                    entity.update(from: message)
                }
                
                try context.managedObjectContext.save()
            }
        } catch {
            logger.error("Failed to fetch messages.", metadata: ["Error": .string(String(describing: error))])
            throw error
        }
    }
    
    private func deleteLocalMessages(managedObjectContext: NSManagedObjectContext) async throws {
        try await managedObjectContext.performAsync { [managedObjectContext] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.Message> = EurofurenceKit.Message.fetchRequest()
            fetchRequest.predicate = NSPredicate(value: true)
            
            let messages = try managedObjectContext.fetch(fetchRequest)
            for message in messages {
                managedObjectContext.delete(message)
            }
            
            try managedObjectContext.save()
        }
    }
    
}
