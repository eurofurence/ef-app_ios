import EurofurenceModel

class CapturingPrivateMessageObserver: PrivateMessageObserver {
    
    enum ReadState {
        case unset
        case unread
        case read
    }
    
    private(set) var currentReadState: ReadState = .unset
    
    func messageMarkedUnread() {
        currentReadState = .unread
    }
    
    func messageMarkedRead() {
        currentReadState = .read
    }
    
}
