import Foundation

public extension Optional {

    func defaultingTo(_ `default`: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value

        case .none:
            return try `default`()
        }
    }

}
