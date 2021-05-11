import Foundation

public protocol EventObserver: AnyObject {
    
    func eventDidBecomeFavourite(_ event: Event)
    func eventDidBecomeUnfavourite(_ event: Event)
    
}
