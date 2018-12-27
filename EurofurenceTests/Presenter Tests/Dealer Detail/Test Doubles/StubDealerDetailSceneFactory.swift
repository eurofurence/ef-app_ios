//
//  StubDealerDetailSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit

class StubDealerDetailSceneFactory: DealerDetailSceneFactory {

    let scene = CapturingDealerDetailScene()
    func makeDealerDetailScene() -> UIViewController & DealerDetailScene {
        return scene
    }

}
