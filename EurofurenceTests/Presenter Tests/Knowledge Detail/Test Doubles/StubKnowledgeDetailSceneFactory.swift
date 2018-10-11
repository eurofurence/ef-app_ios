//
//  StubKnowledgeDetailSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class StubKnowledgeDetailSceneFactory: KnowledgeDetailSceneFactory {

    let interface = CapturingKnowledgeDetailScene()
    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene {
        return interface
    }

}
