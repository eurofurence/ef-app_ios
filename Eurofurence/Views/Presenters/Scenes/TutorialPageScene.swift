//
//  TutorialPageScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

protocol TutorialPageScene {

    weak var tutorialPageSceneDelegate: TutorialPageSceneDelegate? { get set }

    func showPageTitle(_ title: String?)
    func showPageDescription(_ description: String?)
    func showPageImage(_ image: UIImage?)

    func showPrimaryActionButton()
    func showPrimaryActionDescription(_ primaryActionDescription: String)

    func showSecondaryActionButton()
    func showSecondaryActionDescription(_ secondaryActionDescription: String)

}

protocol TutorialPageSceneDelegate: class {

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene)
    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene)

}
