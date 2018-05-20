//
//  EventDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, EventDetailScene {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.eventDetailSceneDidLoad()
    }

    // MARK: EventDetailScene

    private var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(using binder: EventDetailBinder) {

    }

}
