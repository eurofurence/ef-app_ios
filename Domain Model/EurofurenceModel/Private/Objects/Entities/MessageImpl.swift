import EventBus
import Foundation

class MessageImpl: Message, Comparable {
    
    static func == (lhs: MessageImpl, rhs: MessageImpl) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: MessageImpl, rhs: MessageImpl) -> Bool {
        return lhs.receivedDateTime.compare(rhs.receivedDateTime) == .orderedDescending
    }
    
    struct ReadEvent {
        var message: Message
    }
    
    private let eventBus: EventBus

    var identifier: MessageIdentifier
    var authorName: String
    var receivedDateTime: Date
    var subject: String
    var contents: String
    var isRead: Bool

    init(eventBus: EventBus, characteristics: MessageCharacteristics) {
        self.eventBus = eventBus
        
        self.identifier = MessageIdentifier(characteristics.identifier)
        self.authorName = characteristics.authorName
        self.receivedDateTime = characteristics.receivedDateTime
        self.subject = characteristics.subject
        self.contents = characteristics.contents
        self.isRead = characteristics.isRead
    }
    
    func markAsRead() {
        isRead = true
        eventBus.post(ReadEvent(message: self))
    }

}
