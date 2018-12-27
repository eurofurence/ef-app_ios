//
//  CapturingNewsComponentHeaderScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel

class CapturingNewsComponentHeaderScene: NewsComponentHeaderScene {

    private(set) var capturedTitle: String?
    func setComponentTitle(_ title: String?) {
        capturedTitle = title
    }

}
