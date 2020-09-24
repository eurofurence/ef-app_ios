import EurofurenceModel

class CapturingPrivateMessageObserver: PrivateMessageObserver {
    
    enum ReadState {
        case unset
        case unread
    }
    
    private(set) var currentReadState: ReadState = .unset
    
    func messageMarkedUnread() {
        currentReadState = .unread
    }
    
}
