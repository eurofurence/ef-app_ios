import EurofurenceModel
import Foundation
import KnowledgeDetailComponent

// MARK: - ExpressibleBySingleParameterURL

extension KnowledgeEntryContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"KnowledgeEntries/(.*)"#)
    
    typealias CaptureGroupContents = KnowledgeEntryIdentifier
    
    init(singleParameterCaptureGroup: KnowledgeEntryIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
