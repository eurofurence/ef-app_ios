import EurofurenceModel
import UIKit

public struct EventActivityItemSource: Equatable {
    
    public static func == (lhs: EventActivityItemSource, rhs: EventActivityItemSource) -> Bool {
        lhs.event.identifier == rhs.event.identifier
    }
    
    public var event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
}
