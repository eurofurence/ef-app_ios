//
//  CompleteTutorial.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct CompleteTutorial: TutorialPageDelegate {

    var delegate: TutorialModuleDelegate
    var tutorialStateProviding: UserCompletedTutorialStateProviding

    func tutorialPageCompletedByUser(_ tutorialPage: TutorialPage) {
        delegate.tutorialModuleDidFinishPresentingTutorial()
        tutorialStateProviding.markTutorialAsComplete()
    }

}
