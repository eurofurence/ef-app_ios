//
//  CapturingKnowledgeDetailModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingKnowledgeDetailModuleDelegate: KnowledgeDetailModuleDelegate {
    
    private(set) var capturedLinkToOpen: Link?
    func knowledgeDetailModuleDidSelectLink(_ link: Link) {
        capturedLinkToOpen = link
    }
    
}
