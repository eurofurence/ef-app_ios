import Foundation

public protocol DateFormatterProtocol {

    func string(from date: Date) -> String

}

extension DateFormatter: DateFormatterProtocol {}
