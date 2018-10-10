//
//  CapturingExternalContentHandler.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingExternalContentHandler: ExternalContentHandler {
    
    private(set) var capturedExternalContentURL: URL?
    func handleExternalContent(url: URL) {
        capturedExternalContentURL = url
    }
    
}
