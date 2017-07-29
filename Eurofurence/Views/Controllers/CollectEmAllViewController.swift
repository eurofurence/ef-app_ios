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

	private static let baseUrl = URL(string: "https://app.eurofurence.org/collectemall/")!
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
		webView?.load(URLRequest(url: CollectEmAllViewController.baseUrl))
	}

	@IBAction func refreshWebView(_ sender: UIButton) {
		webView?.reloadFromOrigin()
	}
}
