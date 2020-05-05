import UIKit

class TutorialPageViewController: UIViewController, TutorialPageScene {

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

    var tutorialPageSceneDelegate: TutorialPageSceneDelegate?

    func showPageTitle(_ title: String?) {
        tutorialPageTitleLabel.text = title
    }

    func showPageDescription(_ description: String?) {
        tutorialPageDescriptionLabel.text = description
    }

    func showPageImage(_ image: UIImage?) {
        tutorialPageImageView.image = image
    }

    func showPrimaryActionButton() {
        primaryActionButton.isHidden = false
    }

    func showPrimaryActionDescription(_ primaryActionDescription: String) {
        primaryActionButton.setTitle(primaryActionDescription, for: .normal)
    }

    func showSecondaryActionButton() {
        secondaryActionButton.isHidden = false
    }

    func showSecondaryActionDescription(_ secondaryActionDescription: String) {
        secondaryActionButton.setTitle(secondaryActionDescription, for: .normal)
    }

}
