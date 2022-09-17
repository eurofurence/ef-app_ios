import CoreData
import EurofurenceWebAPI
import Logging

class UpdateLocalMessagesOperation: UpdateOperation {
    
    private let logger = Logger(label: "UpdateMessages")
    
    func execute(context: UpdateOperationContext) async throws {
        if let credential = context.keychain.credential, credential.isValid {
            try await fetchAndUpdateMessages(authenticationToken: credential.authenticationToken, context: context)
        } else {
            try await deleteLocalMessages(managedObjectContext: context.managedObjectContext)
        }
    }
    
    private func fetchAndUpdateMessages(
        authenticationToken: AuthenticationToken,
        context: UpdateOperationContext
    ) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Parallelize fetching new messages while updating the remote of any read messages states that failed
            // to send previously
            group.addTask { [self] in
                try await fetchMessages(authenticationToken: authenticationToken, context: context)
            }
            
            group.addTask { [self] in
                try await uploadPendingReadStatusNotifications(
                    authenticationToken: authenticationToken,
                    context: context
                )
            }
            
            try await group.waitForAll()
        }
    }
    
    private func fetchMessages(
        authenticationToken: AuthenticationToken,
        context: UpdateOperationContext
    ) async throws {
        do {
            let request = APIRequests.FetchMessages(authenticationToken: authenticationToken)
            let messages = try await context.api.execute(request: request)
            
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
    
    private func uploadPendingReadStatusNotifications(
        authenticationToken: AuthenticationToken,
        context: UpdateOperationContext
    ) async throws {
        let managedObjectContext = context.managedObjectContext
        let messagesNeedingStatusUpate: [Message] = try await managedObjectContext.performAsync {
            let fetchRequest: NSFetchRequest<EurofurenceKit.Message> = EurofurenceKit.Message.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "needsReadStatusUpdate == YES")
            
            return try context.managedObjectContext.fetch(fetchRequest)
        }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for message in messagesNeedingStatusUpate {
                group.addTask {
                    await message.submitReadStatus()
                }
            }
            
            try await group.waitForAll()
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
