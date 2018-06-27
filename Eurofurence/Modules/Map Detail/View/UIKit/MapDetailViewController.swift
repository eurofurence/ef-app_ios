//
//  MapDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapDetailViewController: UIViewController, MapDetailScene {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.mapDetailSceneDidLoad()
    }

    // MARK: MapDetailScene

    private var delegate: MapDetailSceneDelegate?
    func setDelegate(_ delegate: MapDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setMapImagePNGData(_ data: Data) {

    }

    func setMapTitle(_ title: String) {
        navigationItem.title = title
    }

}
