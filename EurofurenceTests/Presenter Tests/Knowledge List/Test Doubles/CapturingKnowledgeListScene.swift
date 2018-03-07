//
//  CapturingKnowledgeListScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingKnowledgeListScene: UIViewController, KnowledgeListScene {
    
    private(set) var delegate: KnowledgeListSceneDelegate?
    func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setKnowledgeListTitle(_ title: String) {
        capturedTitle = title
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
    fileprivate var binder: KnowledgeListBinder?
    func prepareToDisplayKnowledgeGroups(entriesPerGroup: [Int], binder: KnowledgeListBinder) {
        capturedEntriesPerGroup = entriesPerGroup
        self.binder = binder
    }
    
}

extension CapturingKnowledgeListScene {
    
    func bind(_ headerScene: KnowledgeGroupHeaderScene, toGroupAt index: Int) {
        binder?.bind(headerScene, toGroupAt: index)
    }
    
    func bind(_ headerScene: KnowledgeGroupEntryScene, toEntryInGroup groupIndex: Int, at entryIndex: Int) {
        binder?.bind(headerScene, toEntryInGroup: groupIndex, at: entryIndex)
    }
    
    func simulateSelectingKnowledgeEntry(inGroup groupIndex: Int, at entryIndex: Int) {
        delegate?.knowledgeListSceneDidSelectKnowledgeEntry(inGroup: groupIndex, at: entryIndex)
    }
    
}
