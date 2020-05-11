import Eurofurence
import EurofurenceModel
import Foundation

class CapturingDateFormatter: DateFormatterProtocol {

    var stubString = "Stub"
    private(set) var capturedDate: Date?
    func string(from date: Date) -> String {
        capturedDate = date
        return stubString
    }

}
