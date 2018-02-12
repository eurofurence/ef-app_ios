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
    
    private(set) var didShowLoadingIndicator = false
    func showLoadingIndicator() {
        didShowLoadingIndicator = true
    }
    
    private(set) var didHideLoadingIndicator = false
    func hideLoadingIndicator() {
        didHideLoadingIndicator = true
    }
    
    private(set) var capturedEntriesPerGroup: [Int] = []
    func prepareToDisplayKnowledgeGroups(entriesPerGroup: [Int]) {
        capturedEntriesPerGroup = entriesPerGroup
    }
    
}
