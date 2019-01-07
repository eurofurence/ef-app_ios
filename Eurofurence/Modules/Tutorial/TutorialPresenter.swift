//
//  TutorialPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class TutorialPresenter {

    // MARK: Properties

    private let delegate: TutorialModuleDelegate
    private var context: TutorialPresentationContext

    // MARK: Initialization

    init(delegate: TutorialModuleDelegate,
         context: TutorialPresentationContext) {
        self.delegate = delegate
        self.context = context

        let completeTutorial = CompleteTutorial(delegate: delegate,
                                                tutorialStateProviding: context.tutorialStateProviding)
        _ = InitiateDownloadTutorialPagePresenter(delegate: completeTutorial,
                                                  tutorialScene: context.tutorialScene,
                                                  alertRouter: context.alertRouter,
                                                  presentationAssets: context.presentationAssets,
                                                  networkReachability: context.networkReachability)
    }

}
