import Foundation
import UIKit

public protocol TutorialPageScene {

    var tutorialPageSceneDelegate: TutorialPageSceneDelegate? { get set }

    func showPageTitle(_ title: String?)
    func showPageDescription(_ description: String?)
    func showPageImage(_ image: UIImage?)

    func showPrimaryActionButton()
    func showPrimaryActionDescription(_ primaryActionDescription: String)

    func showSecondaryActionButton()
    func showSecondaryActionDescription(_ secondaryActionDescription: String)

}

public protocol TutorialPageSceneDelegate {

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene)
    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene)

}
