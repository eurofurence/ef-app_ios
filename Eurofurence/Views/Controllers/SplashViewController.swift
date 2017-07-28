//
//  SplashViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin
import UIKit
import ReactiveSwift
import Whisper

class SplashViewController: UIViewController, SplashScene,
                            DataStoreLoadDelegate,
                            DataStoreRefreshDelegate {

    // MARK: IBOutlets

    @IBOutlet weak var loadingProgressView: UIProgressView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var hieroglyphLabel: UILabel!

    // MARK: Properties

    private lazy var loadController = DataStoreLoadController.shared
    private lazy var refreshController = DataStoreRefreshController.shared

    // MARK: Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingProgressView.progress = 0

        let string = String(makeRandomHieroglyphCharacter())
        hieroglyphLabel.text = string
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

		loadController.add(self, doPrepend: true)
        refreshController.add(self, doPrepend: true)
        loadController.loadFromStore()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
		refreshController.remove(self)
        loadController.remove(self)
    }

    // MARK: SplashScene

    func showQuote(_ quote: String) {
        quoteLabel.text = quote
    }

    func showQuoteAuthor(_ author: String) {
        quoteAuthorLabel.text = "- \(author)"
    }

    // MARK: DataStoreLoadDelegate

    func dataStoreLoadDidBegin() {

    }

    func dataStoreLoadDidProduceProgress(_ progress: Progress) {
        loadingProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
    }

    func dataStoreLoadDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

    // MARK: DataStoreRefreshDelegate

    func dataStoreRefreshDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {
        loadingProgressView.progress = Float(progress.fractionCompleted)
    }

	func dataStoreRefreshDidBegin(_ lastSync: Date?) { }
    func dataStoreRefreshDidFailWithError(_ error: Error) {
		if let error = error as? ActionError<NSError> {
			switch error {
			case let .producerFailed(error):
				if error.domain == ApiConnectionError.errorDomain {
					let tutorialFinishedKey = UserDefaultsTutorialStateProvider.FinishedTutorialKey
					UserDefaults.standard.set(false, forKey: tutorialFinishedKey)
					UserDefaults.standard.synchronize()

					let window = UIApplication.shared.delegate!.window!
					let alert = UIAlertController(title: "Download Error", message: "Failed to download data from server. Please try again.", preferredStyle: .alert)
					alert.addAction(UIAlertAction.init(title: "Close", style: .cancel, handler: { _ in
						PresentationTier.assemble(window: window!)
					}))
					window!.rootViewController!.present(alert, animated: true)
					return
				}
			default:
				break
			}
		}
		performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
	}

    // MARK: Private

    private func makeRandomHieroglyphCharacter() -> Character {
        let hieroglyphRange = 80...123
        let lower = UInt32(hieroglyphRange.lowerBound)
        let upper = UInt32(hieroglyphRange.upperBound)
        let randomisedValueInRange = lower + arc4random_uniform(upper - lower + 1)
        let scalar = UnicodeScalar(randomisedValueInRange)!
        return Character(scalar)
    }

}
