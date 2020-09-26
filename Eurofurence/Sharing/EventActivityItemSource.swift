import EurofurenceModel
import UIKit

public class EventActivityItemSource: NSObject {
    
    public var event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? EventActivityItemSource else { return false }
        return event.identifier == other.event.identifier
    }
    
}

// MARK: - UIActivityItemSource

extension EventActivityItemSource: UIActivityItemSource {
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        event.makeContentURL()
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        event.makeContentURL()
    }
    
}
