import Foundation

struct FoundationRelativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter {

    static let shared = FoundationRelativeTimeIntervalCountdownFormatter()
    private var formatter: DateComponentsFormatter

    private init() {
        formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
    }

    func relativeString(from timeInterval: TimeInterval) -> String {
        guard let string = formatter.string(from: timeInterval) else {
            fatalError("Unable to format \(timeInterval) into String")
        }
        
        return string
    }

}
