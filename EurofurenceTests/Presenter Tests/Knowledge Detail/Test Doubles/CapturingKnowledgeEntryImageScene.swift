//
//  CapturingKnowledgeEntryImageScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingKnowledgeEntryImageScene: KnowledgeEntryImageScene {

    private(set) var capturedImagePNGData: Data?
    func showImagePNGData(_ data: Data) {
        capturedImagePNGData = data
    }

}
