import UIKit
import WebKit

class HybridWebViewController: UIViewController, HybridWebScene {

    // MARK: Properties

    private var webView: WKWebView?
    private var loadingObservation: NSKeyValueObservation?
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assembleWebView()
        delegate?.hybridWebSceneDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView?.frame = view.bounds
    }

    // MARK: HybridWebScene

    private var delegate: HybridWebSceneDelegate?
    func setDelegate(_ delegate: HybridWebSceneDelegate) {
        self.delegate = delegate
    }

    func setSceneShortTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
        restorationIdentifier = shortTitle
    }

    func setSceneTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setSceneIcon(pngData: Data) {
        guard let image = UIImage(data: pngData) else { return }
        
        tabBarItem.image = scaleImageForTabBarPresentation(image)
    }

    func loadContents(of urlRequest: URLRequest) {
        webView?.removeFromSuperview()
        assembleWebView()
        
        webView?.load(urlRequest)
    }
    
    // MARK: Private
    
    private func assembleWebView() {
        loadingObservation = nil
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        
        self.webView = webView
        
        loadingObservation = webView.observe(\.isLoading, changeHandler: { [weak self] (webView, _) in
            self?.loadingIndicator.isHidden = !webView.isLoading
        })
        
        view.bringSubviewToFront(loadingIndicator)
    }
    
    private func scaleImageForTabBarPresentation(_ image: UIImage) -> UIImage {
        let tabBarIconSize = CGSize(width: 25.0, height: 25.0)
        let context = UIGraphicsImageRenderer(size: tabBarIconSize)
        
        return context.image { _ in
            image.draw(in: CGRect(origin: .zero, size: tabBarIconSize))
        }
    }

}
