import Foundation

public protocol ShareableURLFactory {
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL
    
}
