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
    private let characteristics: MessageCharacteristics
    private var observers: [WeakObserver] = []
    
    var identifier: MessageIdentifier {
        MessageIdentifier(characteristics.identifier)
    }
    
    var authorName: String {
        characteristics.authorName
    }
    
    var receivedDateTime: Date {
        characteristics.receivedDateTime
    }
    
    var subject: String {
        characteristics.subject
    }
    
    var contents: String {
        characteristics.contents
    }
    
    private(set) var isRead: Bool
    
    init(eventBus: EventBus, characteristics: MessageCharacteristics) {
        self.eventBus = eventBus
        self.characteristics = characteristics
        isRead = characteristics.isRead
    }
    
    func add(_ observer: PrivateMessageObserver) {
        observers.append(WeakObserver(observer))
        
        if isRead {
            observer.messageMarkedRead()
        } else {
            observer.messageMarkedUnread()
        }
    }
    
    func remove(_ observer: PrivateMessageObserver) {
        observers.removeAll(where: { $0.isReferencing(observer) })
    }
    
    func markAsRead() {
        isRead = true
        eventBus.post(ReadEvent(message: self))
        
        for observer in observers {
            observer.reference?.messageMarkedRead()
        }
    }
    
    private class WeakObserver {
        
        private(set) weak var reference: PrivateMessageObserver?
        
        init(_ reference: PrivateMessageObserver) {
            self.reference = reference
        }
        
        func isReferencing(_ instance: PrivateMessageObserver) -> Bool {
            reference === instance
        }
        
    }

}
