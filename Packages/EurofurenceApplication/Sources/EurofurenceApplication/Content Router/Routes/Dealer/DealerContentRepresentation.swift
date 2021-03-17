import ComponentBase
import EurofurenceModel
import Foundation

public struct DealerContentRepresentation: ContentRepresentation {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}

// MARK: - ExpressibleBySingleParameterURL

extension DealerContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Dealers/(.*)"#)
    
    typealias CaptureGroupContents = DealerIdentifier
    
    init(singleParameterCaptureGroup: DealerIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
