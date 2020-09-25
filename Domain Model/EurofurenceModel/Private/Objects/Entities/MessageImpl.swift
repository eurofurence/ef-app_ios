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
    private var observers: [PrivateMessageObserver] = []

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
    
    func add(_ observer: PrivateMessageObserver) {
        observers.append(observer)
        
        if isRead {
            observer.messageMarkedRead()
        } else {
            observer.messageMarkedUnread()
        }
    }
    
    func remove(_ observer: PrivateMessageObserver) {
        observers.removeAll(where: { $0 === observer })
    }
    
    func markAsRead() {
        isRead = true
        eventBus.post(ReadEvent(message: self))
        
        for observer in observers {
            observer.messageMarkedRead()
        }
    }

}
