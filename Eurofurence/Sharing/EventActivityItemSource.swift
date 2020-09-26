import EurofurenceModel
import UIKit

public class EventActivityItemSource: URLBasedActivityItem {
    
    public var event: Event
    
    public init(event: Event) {
        self.event = event
        super.init(url: event.makeContentURL())
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? EventActivityItemSource else { return false }
        return event.identifier == other.event.identifier
    }
    
}
