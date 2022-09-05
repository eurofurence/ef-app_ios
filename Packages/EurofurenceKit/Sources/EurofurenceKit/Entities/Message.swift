import CoreData
import EurofurenceWebAPI

@objc(Message)
public class Message: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var identifier: String
    @NSManaged public var author: String
    @NSManaged public var subject: String
    @NSManaged public var message: String
    @NSManaged public var receivedDate: Date
    @NSManaged public var readDate: Date?

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
