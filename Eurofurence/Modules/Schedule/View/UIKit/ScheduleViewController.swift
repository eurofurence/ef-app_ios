//
//  ScheduleViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, ScheduleScene {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.scheduleSceneDidLoad()
    }

    // MARK: EventsScene

    private var delegate: ScheduleSceneDelegate?
    func setDelegate(_ delegate: ScheduleSceneDelegate) {
        self.delegate = delegate
    }

    func setScheduleTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {

    }

}
