import Foundation

public protocol RelativeTimeIntervalCountdownFormatter {

    func relativeString(from timeInterval: TimeInterval) -> String

}
