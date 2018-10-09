//
//  StubTutorialModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class StubTutorialModuleFactory: TutorialModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubTutorialModuleFactory {
    
    func simulateTutorialFinished() {
        delegate?.tutorialModuleDidFinishPresentingTutorial()
    }
    
}
