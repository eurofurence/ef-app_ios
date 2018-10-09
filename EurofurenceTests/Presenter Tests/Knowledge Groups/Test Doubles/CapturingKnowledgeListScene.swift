//
//  CapturingKnowledgeListScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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
    
    private(set) var capturedShortTitle: String?
    func setKnowledgeListShortTitle(_ shortTitle: String) {
        capturedShortTitle = shortTitle
    }
    
    private(set) var didShowLoadingIndicator = false
    func showLoadingIndicator() {
        didShowLoadingIndicator = true
    }
    
    private(set) var didHideLoadingIndicator = false
    func hideLoadingIndicator() {
        didHideLoadingIndicator = true
    }
    
    private(set) var capturedEntriesPerGroup: Int?
    fileprivate var binder: KnowledgeListBinder?
    func prepareToDisplayKnowledgeGroups(numberOfGroups: Int, binder: KnowledgeListBinder) {
        capturedEntriesPerGroup = numberOfGroups
        self.binder = binder
    }
    
    private(set) var deselectedIndexPath: IndexPath?
    func deselectKnowledgeEntry(at indexPath: IndexPath) {
        deselectedIndexPath = indexPath
    }
    
}

extension CapturingKnowledgeListScene {
    
    func bind(_ headerScene: KnowledgeGroupScene, toGroupAt index: Int) {
        binder?.bind(headerScene, toGroupAt: index)
    }
    
    func simulateSelectingKnowledgeGroup(at groupIndex: Int) {
        delegate?.knowledgeListSceneDidSelectKnowledgeGroup(at: groupIndex)
    }
    
}
