//
//  SplashViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin
import UIKit

class SplashViewController: UIViewController, SplashScene,
                            DataStoreLoadDelegate,
                            DataStoreRefreshDelegate {

    // MARK: IBOutlets

    @IBOutlet weak var loadingProgressView: UIProgressView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var hieroglyphLabel: UILabel!

    // MARK: Properties

    private lazy var loadController = DataStoreLoadController.shared
    private lazy var refreshController = DataStoreRefreshController.shared

    // MARK: Overrides

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingProgressView.progress = 0

        let string = String(makeRandomHieroglyphCharacter())
        hieroglyphLabel.text = string
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        loadController.add(self)
        refreshController.add(self)
        loadController.loadFromStore()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loadController.remove(self)
    }

    // MARK: SplashScene

    func showQuote(_ quote: String) {
        quoteLabel.text = quote
    }

    // MARK: DataStoreLoadDelegate

    func dataStoreLoadDidBegin() {

    }

    func dataStoreLoadDidProduceProgress(_ progress: Progress) {
        loadingProgressView.progress = Float(progress.fractionCompleted)
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
    func dataStoreRefreshDidFailWithError(_ error: Error) { }

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
