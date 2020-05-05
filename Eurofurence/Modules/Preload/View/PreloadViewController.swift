import UIKit.UIViewController

class PreloadViewController: UIViewController, SplashScene {

    // MARK: IBOutlets

    @IBOutlet private weak var progressDescriptionLabel: UILabel!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func showStaleAppAlert() {
        let alert = UIAlertController(title: .updateRequiredAlertTitle,
                                      message: .updateRequiredAlertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        present(alert, animated: true)
    }

}
