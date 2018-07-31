//
//  StubKnowledgeGroupEntriesSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class StubKnowledgeGroupEntriesSceneFactory: KnowledgeGroupEntriesSceneFactory {
    
    let scene = CapturingKnowledgeGroupEntriesScene()
    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene {
        return scene
    }
    
}
