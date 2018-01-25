//
//  CapturingKnowledgeListScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingKnowledgeListScene: KnowledgeListScene {
    
    private(set) var delegate: KnowledgeListSceneDelegate?
    func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
        self.delegate = delegate
    }
    
}
