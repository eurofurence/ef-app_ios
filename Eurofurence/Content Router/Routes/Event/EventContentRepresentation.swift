import EurofurenceModel
import Foundation

public struct EventContentRepresentation: ContentRepresentation {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}

// MARK: - ExpressibleBySingleParameterURL

extension EventContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Events/(.*)"#)
    
    typealias CaptureGroupContents = EventIdentifier
    
    init(singleParameterCaptureGroup: EventIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
