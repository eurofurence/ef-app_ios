import Foundation

public class EurofurenceISO8601DateFormatter: DateFormatter {
    
    public static let instance = EurofurenceISO8601DateFormatter()
    private let noFractionsDateFormatter = DateFormatter()

    override public init() {
        super.init()

        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)
        dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"

        noFractionsDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        noFractionsDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        noFractionsDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func date(from string: String) -> Date? {
        if let date = noFractionsDateFormatter.date(from: string) {
            return date
        }

        return super.date(from: string)
    }
    
}
