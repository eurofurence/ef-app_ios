import Eurofurence
import EurofurenceModel
import Foundation

class FakeRelativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter {

    private var strings = [TimeInterval: String]()

    func relativeString(from timeInterval: TimeInterval) -> String {
        var output = String.random
        if let previous = strings[timeInterval] {
            output = previous
        } else {
            strings[timeInterval] = output
        }

        return output
    }

}
