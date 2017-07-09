//
//  CapturingTutorialPageScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingTutorialPageScene: TutorialPageScene {

    private(set) var capturedPageTitle: String?
    func showPageTitle(_ title: String?) {
        capturedPageTitle = title
    }

}
