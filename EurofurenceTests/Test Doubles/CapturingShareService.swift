@testable import Eurofurence

class CapturingShareService: ShareService {
    
    private(set) var sharedItem: Any?
    private(set) var sharedItemSender: Any?
    func share(_ item: Any, sender: Any) {
        sharedItem = item
        sharedItemSender = sender
    }
    
}
