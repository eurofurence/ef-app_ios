//
//  StubScheduleSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubScheduleSceneFactory: ScheduleSceneFactory {

    let scene = CapturingScheduleScene()
    func makeEventsScene() -> UIViewController & ScheduleScene {
        return scene
    }

}
