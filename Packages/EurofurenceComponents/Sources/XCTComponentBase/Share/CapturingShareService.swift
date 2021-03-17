import ComponentBase

public class CapturingShareService: ShareService {
    
    public init() {
        
    }
    
    public private(set) var sharedItem: Any?
    public private(set) var sharedItemSender: Any?
    public func share(_ item: Any, sender: Any) {
        sharedItem = item
        sharedItemSender = sender
    }
    
}
