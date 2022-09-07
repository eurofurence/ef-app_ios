import CoreData
import EurofurenceWebAPI
import Logging

@objc(Message)
public class Message: NSManagedObject {
    
    private static let logger = Logger(label: "Message")
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var identifier: String
    @NSManaged public var author: String
    @NSManaged public var subject: String
    @NSManaged public var message: String
    @NSManaged public var receivedDate: Date
    @NSManaged public var readDate: Date?
    
    /// Indicates whether the user has read this message locally, and the read state is pending synchronisation with
    /// the remote.
    @NSManaged var isPendingReadStateUpdateToRemote: Bool
    
    /// Indicates whether the user has read the contents of this message.
    @NSManaged public private(set) var isRead: Bool

}

// MARK: - Marking as Read

extension Message {
    
    /// Marks the message as read, synchronizing the status with the remote store.
    ///
    /// This function will immediatley update the local store for keeping the application state
    /// in sync with the user's action. It will later update the remote store with the read state
    /// of the message.
    public func markRead() async {
        guard isRead == false else { return }
        
        // Update the store now to indicate locally the read has occurred.
        await markAsRead()
        
        managedObjectContext?.performAndWait {
            managedObjectContext?.refresh(self, mergeChanges: true)
        }
        
        // Simultaneously mark the message as read on the remote.
        await submitReadStatus()
    }
    
    private func markAsRead() async {
        guard let persistentContainer = managedObjectContext?.persistentContainer else { return }
        
        let identifier = self.identifier
        let writingContext = persistentContainer.newBackgroundContext()
        
        do {
            try await writingContext.performAsync { [writingContext] in
                let writableMessage = try Message.message(for: identifier, in: writingContext)
                writableMessage.isRead = true
                writableMessage.isPendingReadStateUpdateToRemote = true
                try writingContext.save()
            }
        } catch {
            let metadata: Logger.Metadata = [
                "ID": .string(identifier),
                "Error": .string(String(describing: error))
            ]
            
            Self.logger.error("Failed to update read status for message", metadata: metadata)
        }
    }
    
    func submitReadStatus() async {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let persistentContainer = managedObjectContext.persistentContainer else { return }
        guard let api = managedObjectContext.eurofurenceAPI else { return }
        guard let authenticationToken = managedObjectContext.keychain?.credential?.authenticationToken else { return }
        
        do {
            let request = AcknowledgeMessageRequest(
                authenticationToken: authenticationToken,
                messageIdentifier: identifier
            )
            
            try await api.markMessageAsRead(request: request)
            
            let writingContext = persistentContainer.newBackgroundContext()
            
            try writingContext.performAndWait { [writingContext] in
                let writableMessage = try Message.message(for: identifier, in: writingContext)
                writableMessage.isPendingReadStateUpdateToRemote = false
                
                try writingContext.save()
            }
        } catch {
            let metadata: Logger.Metadata = [
                "ID": .string(identifier),
                "Error": .string(String(describing: error))
            ]
            
            Self.logger.error("Marking message as read failed", metadata: metadata)
        }
    }
    
}

// MARK: - Fetching

extension Message {
    
    static func message(for identifier: String, in managedObjectContext: NSManagedObjectContext) throws -> Message {
        return try managedObjectContext.performAndWait {
            let fetchRequest: NSFetchRequest<EurofurenceKit.Message> = EurofurenceKit.Message.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1
            
            let results = try managedObjectContext.fetch(fetchRequest)
            if let message = results.first {
                return message
            } else {
                let message = Message(context: managedObjectContext)
                message.identifier = identifier
                
                return message
            }
        }
    }
    
}

// MARK: - Updating from remote entity

extension Message {
    
    func update(from message: EurofurenceWebAPI.Message) {
        identifier = message.id
        author = message.author
        subject = message.subject
        self.message = message.message
        receivedDate = message.receivedDate
        readDate = message.readDate
    }
    
}
