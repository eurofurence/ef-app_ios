//
//  SplashViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, DataStoreLoadDelegate {

    // MARK: Properties

    private lazy var loadController = DataStoreLoadController.shared

    // MARK: Overrides

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

    }

    func dataStoreLoadDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

}
