import Foundation

public extension Optional {

    @discardableResult
    func `let`<T>(_ block: (Wrapped) throws -> T?) rethrows -> T? {
        if case .some(let value) = self { return try block(value) } else { return nil }
    }

    func defaultingTo(_ `default`: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value

        case .none:
            return try `default`()
        }
    }

}
