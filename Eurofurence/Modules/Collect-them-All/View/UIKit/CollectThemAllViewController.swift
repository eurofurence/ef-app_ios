import UIKit
import WebKit

class CollectThemAllViewController: UIViewController, CollectThemAllScene {

    // MARK: Properties

    private var webView: WKWebView?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.allowsLinkPreview = false
        webView?.allowsBackForwardNavigationGestures = true
        view = webView
        delegate?.collectThemAllSceneDidLoad()
    }

    // MARK: CollectThemAllScene

    private var delegate: CollectThemAllSceneDelegate?
    func setDelegate(_ delegate: CollectThemAllSceneDelegate) {
        self.delegate = delegate
    }

    func setShortCollectThemAllTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    func setCollectThemAllTitle(_ title: String) {
        navigationItem.title = title
    }

    func loadGame(at urlRequest: URLRequest) {
        webView?.load(urlRequest)
    }

}
