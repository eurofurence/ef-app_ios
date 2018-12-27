//
//  CapturingURLOpener.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation.NSURL

public class CapturingURLOpener: URLOpener {

    public init() {

    }

    public func canOpen(_ url: URL) -> Bool {
        return true
    }

    private(set) public var capturedURLToOpen: URL?
    public func open(_ url: URL) {
        capturedURLToOpen = url
    }

}

public class HappyPathURLOpener: CapturingURLOpener {

    public override func canOpen(_ url: URL) -> Bool {
        return true
    }

}

public class UnhappyPathURLOpener: CapturingURLOpener {

    public override func canOpen(_ url: URL) -> Bool {
        return false
    }

}
