//
//  StubAnnouncementsSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit

class StubAnnouncementsSceneFactory: AnnouncementsSceneFactory {

    let scene = CapturingAnnouncementsScene()
    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene {
        return scene
    }

}
