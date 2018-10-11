//
//  CapturingKnowledgeGroupEntryScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore

class CapturingKnowledgeGroupEntryScene: KnowledgeGroupEntryScene {

    private(set) var capturedTitle: String?
    func setKnowledgeEntryTitle(_ title: String) {
        capturedTitle = title
    }

}
