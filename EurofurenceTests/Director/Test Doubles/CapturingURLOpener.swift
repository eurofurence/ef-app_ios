//
//  CapturingURLOpener.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSURL

class CapturingURLOpener: URLOpener {
    
    func canOpen(_ url: URL) -> Bool {
        return true
    }
    
    private(set) var capturedURLToOpen: URL?
    func open(_ url: URL) {
        capturedURLToOpen = url
    }
    
}
