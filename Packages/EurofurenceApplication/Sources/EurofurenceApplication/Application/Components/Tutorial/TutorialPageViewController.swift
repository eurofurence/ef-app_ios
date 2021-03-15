import EurofurenceComponentBase
import UIKit

public class TutorialPageViewController: UIViewController, TutorialPageScene {

    // MARK: IBOutlets

    @IBOutlet private weak var tutorialPageImageView: UIImageView!
    @IBOutlet private weak var tutorialPageTitleLabel: UILabel!
    @IBOutlet private weak var tutorialPageDescriptionLabel: UILabel!
    @IBOutlet private weak var primaryActionButton: UIButton!
    @IBOutlet private weak var secondaryActionButton: RoundedCornerButton!

    // MARK: IBActions

    @IBAction private func performPrimaryAction(_ sender: Any) {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapPrimaryActionButton(self)
    }

    @IBAction private func performSecondaryAction(_ sender: Any) {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapSecondaryActionButton(self)
    }

    // MARK: TutorialPageScene

    public var tutorialPageSceneDelegate: TutorialPageSceneDelegate?

    public func showPageTitle(_ title: String?) {
        tutorialPageTitleLabel.text = title
    }

    public func showPageDescription(_ description: String?) {
        tutorialPageDescriptionLabel.text = description
    }

    public func showPageImage(_ image: UIImage?) {
        tutorialPageImageView.image = image
    }

    public func showPrimaryActionButton() {
        primaryActionButton.isHidden = false
    }

    public func showPrimaryActionDescription(_ primaryActionDescription: String) {
        primaryActionButton.setTitle(primaryActionDescription, for: .normal)
    }

    public func showSecondaryActionButton() {
        secondaryActionButton.isHidden = false
    }

    public func showSecondaryActionDescription(_ secondaryActionDescription: String) {
        secondaryActionButton.setTitle(secondaryActionDescription, for: .normal)
    }

}
