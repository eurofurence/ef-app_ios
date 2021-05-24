import ComponentBase
import EurofurenceModel
import Foundation

public struct KnowledgeEntryContentRepresentation: ContentRepresentation {
    
    public var identifier: KnowledgeEntryIdentifier
    
    public init(identifier: KnowledgeEntryIdentifier) {
        self.identifier = identifier
    }
    
}

// MARK: - ExpressibleBySingleParameterURL

extension KnowledgeEntryContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"KnowledgeEntries/(.*)"#)
    
    typealias CaptureGroupContents = KnowledgeEntryIdentifier
    
    init(singleParameterCaptureGroup: KnowledgeEntryIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
