import EurofurenceModel
import EventDetailComponent
import Foundation

extension EventContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Events/(.*)"#)
    
    typealias CaptureGroupContents = EventIdentifier
    
    init(singleParameterCaptureGroup: EventIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}
