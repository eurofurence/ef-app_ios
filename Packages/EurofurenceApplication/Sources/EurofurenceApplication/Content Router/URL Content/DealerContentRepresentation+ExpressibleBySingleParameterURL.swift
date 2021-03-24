import DealerComponent
import EurofurenceModel
import Foundation

extension DealerContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Dealers/(.*)"#)
    
    typealias CaptureGroupContents = DealerIdentifier
    
    init(singleParameterCaptureGroup: DealerIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
