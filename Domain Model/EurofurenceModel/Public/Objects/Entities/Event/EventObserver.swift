import Foundation

public protocol EventObserver: class {
    
    func eventDidBecomeFavourite(_ event: Event)
    func eventDidBecomeUnfavourite(_ event: Event)
    
}
