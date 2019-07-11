import Foundation

public protocol ShareableURLFactory {
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL
    func makeURL(for dealerIdentifier: DealerIdentifier) -> URL
    
}
