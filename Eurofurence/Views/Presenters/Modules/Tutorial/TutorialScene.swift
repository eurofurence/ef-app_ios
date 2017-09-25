//
//  TutorialScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol TutorialSceneFactory {

    func makeTutorialScene() -> TutorialScene

}

protocol TutorialScene: class {

    func showTutorialPage() -> TutorialPageScene

}
