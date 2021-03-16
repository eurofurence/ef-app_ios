import EurofurenceComponentBase
import EurofurenceModel
import Foundation

public struct KnowledgeEntryContentRepresentation: ContentRepresentation {
    
    public var identifier: KnowledgeEntryIdentifier
    
    public init(identifier: KnowledgeEntryIdentifier) {
        self.identifier = identifier
    }
    
}

// MRK: - ExpressibleBySingleParameterURL

extension KnowledgeEntryContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"KnowledgeEntries/(.*)"#)
    
    typealias CaptureGroupContents = KnowledgeEntryIdentifier
    
    init(singleParameterCaptureGroup: KnowledgeEntryIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
