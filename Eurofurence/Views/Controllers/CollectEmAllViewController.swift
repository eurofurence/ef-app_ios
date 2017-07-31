//
//  CollectEmAllViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import WebKit

class CollectEmAllViewController: UIViewController, WKUIDelegate {
	// MARK: IBOutlets

	@IBOutlet weak var refreshButton: UIButton!

	// MARK: Properties

    private static let baseURLString = "https://app.eurofurence.org/collectemall/"
	private var webView: WKWebView?

	// MARK: Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
		let webConfiguration = WKWebViewConfiguration()
		webConfiguration.preferences.javaScriptEnabled = true
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView?.allowsLinkPreview = false
		webView?.uiDelegate = self
		view = webView

        let store = KeychainLoginCredentialStore()
        var urlString = CollectEmAllViewController.baseURLString
        if let credential = store.persistedCredential, credential.tokenExpiryDate.compare(Date()) == .orderedDescending {
            urlString.append("#token-\(credential.authenticationToken)")
        }

        if let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
        }
	}

	@IBAction func refreshWebView(_ sender: Any) {
		webView?.reloadFromOrigin()
	}
}
