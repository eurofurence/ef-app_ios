import UIKit
import WebKit

class HybridWebViewController: UIViewController, HybridWebScene {

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
        delegate?.hybridWebSceneDidLoad()
    }

    // MARK: HybridWebScene

    private var delegate: HybridWebSceneDelegate?
    func setDelegate(_ delegate: HybridWebSceneDelegate) {
        self.delegate = delegate
    }

    func setSceneShortTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    func setSceneTitle(_ title: String) {
        navigationItem.title = title
    }

    func loadContents(of urlRequest: URLRequest) {
        webView?.load(urlRequest)
    }

}
