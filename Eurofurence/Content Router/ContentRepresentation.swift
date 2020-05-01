import Foundation

public protocol ContentRepresentation: Equatable {
    
    func describe(to recipient: ContentRepresentationRecipient)
    
}
