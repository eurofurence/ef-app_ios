//
//  SplashViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, DataStoreLoadDelegate {

    // MARK: IBOutlets

    @IBOutlet weak var loadingProgressView: UIProgressView!

    // MARK: Properties

    private lazy var loadController = DataStoreLoadController.shared

    // MARK: Overrides

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingProgressView.progress = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        loadController.add(self)
        loadController.loadFromStore()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loadController.remove(self)
    }

    // MARK: DataStoreLoadDelegate

    func dataStoreLoadDidBegin() {

    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {
        loadingProgressView.progress = Float(progress.fractionCompleted)
    }

    func dataStoreLoadDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

}
