//
//  CapturingAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingAction: TutorialAction {
    
    private(set) var didRun = false
    private var delegate: TutorialActionDelegate?
    func run(_ delegate: TutorialActionDelegate) {
        didRun = true
        self.delegate = delegate
    }
    
    func notifyHandlerActionDidFinish() {
        delegate?.tutorialActionDidFinish(self)
    }
    
}
