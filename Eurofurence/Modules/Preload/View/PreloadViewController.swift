import UIKit.UIViewController

class PreloadViewController: UIViewController, SplashScene {

    // MARK: IBOutlets

    @IBOutlet weak var progressDescriptionLabel: UILabel!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pantone330U
        progressDescriptionLabel.text = .downloadingLatestData
        progressDescriptionLabel.textColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.splashSceneWillAppear(self)
    }

    // MARK: SplashScene

    var delegate: SplashSceneDelegate?

    func showProgress(_ progress: Float, progressDescription: String) {
        progressDescriptionLabel.text = progressDescription
    }

}
