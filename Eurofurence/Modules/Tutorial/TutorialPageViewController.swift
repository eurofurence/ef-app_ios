import UIKit

class TutorialPageViewController: UIViewController, TutorialPageScene {

    // MARK: IBOutlets

    @IBOutlet weak var tutorialPageImageView: UIImageView!
    @IBOutlet weak var tutorialPageTitleLabel: UILabel!
    @IBOutlet weak var tutorialPageDescriptionLabel: UILabel!
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: RoundedCornerButton!

    // MARK: IBActions

    @IBAction func performPrimaryAction(_ sender: Any) {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapPrimaryActionButton(self)
    }

    @IBAction func performSecondaryAction(_ sender: Any) {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapSecondaryActionButton(self)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pantone330U
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
