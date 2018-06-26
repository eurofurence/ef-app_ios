//
//  MapsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, MapsScene {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.mapsSceneDidLoad()
    }

    // MARK: MapsScene

    private var delegate: MapsSceneDelegate?
    func setDelegate(_ delegate: MapsSceneDelegate) {
        self.delegate = delegate
    }

    func setMapsTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfMaps: Int) {

    }

}
