import EurofurenceModel
import Foundation

class CapturingConventionStartDateConsumer: ConventionStartDateConsumer {
    
    private(set) var capturedStartDate: Date?
    func conventionStartDateDidChange(to startDate: Date) {
        capturedStartDate = startDate
    }
    
}
