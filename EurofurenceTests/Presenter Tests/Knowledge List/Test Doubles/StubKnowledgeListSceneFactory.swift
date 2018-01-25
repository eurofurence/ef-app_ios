//
//  StubKnowledgeListSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubKnowledgeListSceneFactory: KnowledgeListSceneFactory {
    
    let scene = CapturingKnowledgeListScene()
    func makeKnowledgeListScene() -> KnowledgeListScene {
        return scene
    }
    
}
