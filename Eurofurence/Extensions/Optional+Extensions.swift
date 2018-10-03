//
//  Optional+Extensions.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension Optional {

    @discardableResult
    public func `let`<T>(_ block: (Wrapped) throws -> T?) rethrows -> T? {
        if case .some(let value) = self { return try block(value) } else { return nil }
    }

    public func or(_ `default`: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value

        case .none:
            return try `default`()
        }
    }

}
