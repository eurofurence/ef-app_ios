import Foundation

public struct Identifier<T>: Equatable, Hashable, RawRepresentable {

    public typealias RawValue = String

    public init(_ value: String) {
        self.rawValue = value
    }

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public var rawValue: String

}
