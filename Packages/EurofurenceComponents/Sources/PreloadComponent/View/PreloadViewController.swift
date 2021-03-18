import UIKit.UIViewController

class PreloadViewController: UIViewController, SplashScene {

    // MARK: IBOutlets

    @IBOutlet private weak var progressDescriptionLabel: UILabel!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        progressDescriptionLabel.text = NSLocalizedString(
            "DownloadingLatestData",
            bundle: .module,
            comment: "Placeholder string displayed on the preload page to indicate to the user the app is updating"
        )
        
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
        let title = NSLocalizedString(
            "UpdateRequiredAlertTitle",
            bundle: .module,
            comment: "Title used for the alert telling the user they need to update their app"
        )
        
        let message = NSLocalizedString(
            "UpdateRequiredAlertMessage",
            bundle: .module,
            comment: "Message body for the alert telling the user they need to update their app"
        )
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        present(alert, animated: true)
    }

}
