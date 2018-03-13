//
//  CapturingLinkScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingLinkScene: LinkScene {
    
    private(set) var capturedLinkName: String?
    func setLinkSame(_ linkName: String) {
        capturedLinkName = linkName
    }
    
}
