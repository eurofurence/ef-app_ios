import Foundation

public protocol EventObserver {
    
    func eventDidBecomeFavourite(_ event: Event)
    func eventDidBecomeUnfavourite(_ event: Event)
    
}
