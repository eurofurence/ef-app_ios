//
//  CapturingKnowledgeGroupHeaderScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit.UIImage

class CapturingKnowledgeGroupHeaderScene: KnowledgeGroupScene {

    private(set) var capturedTitle: String?
    func setKnowledgeGroupTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedFontAwesomeCharacter: Character?
    func setKnowledgeGroupFontAwesomeCharacter(_ character: Character) {
        capturedFontAwesomeCharacter = character
    }

    private(set) var capturedGroupDescription: String?
    func setKnowledgeGroupDescription(_ groupDescription: String) {
        capturedGroupDescription = groupDescription
    }

}
