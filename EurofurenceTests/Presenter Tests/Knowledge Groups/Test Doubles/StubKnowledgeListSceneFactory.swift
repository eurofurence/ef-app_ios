//
//  StubKnowledgeListSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

struct StubKnowledgeListSceneFactory: KnowledgeListSceneFactory {
    
    let scene = CapturingKnowledgeListScene()
    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene {
        return scene
    }
    
}
