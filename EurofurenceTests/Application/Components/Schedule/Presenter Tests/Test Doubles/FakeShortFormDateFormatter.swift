@testable import Eurofurence
import EurofurenceModel
import Foundation

class FakeShortFormDateFormatter: ShortFormDateFormatter {

    func dateString(from date: Date) -> String {
        return "Short Form | \(date.description)"
    }

}
