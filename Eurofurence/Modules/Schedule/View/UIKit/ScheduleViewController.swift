//
//  ScheduleViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, ScheduleScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventTableViewCell.self)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
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

    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {

    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection, binder: binder)
    }

    // MARK: Private

    private class Header: UITableViewHeaderFooterView, ScheduleEventGroupHeader {

        static let identifier = "Header"

        func setEventGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfItemsPerSection: [Int]
        private let binder: ScheduleSceneBinder

        init(numberOfItemsPerSection: [Int], binder: ScheduleSceneBinder) {
            self.numberOfItemsPerSection = numberOfItemsPerSection
            self.binder = binder
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfItemsPerSection.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfItemsPerSection[section]
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
            binder.bind(header, forGroupAt: section)
            return header
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(EventTableViewCell.self)
            binder.bind(cell, forEventAt: indexPath)
            return cell
        }

    }

}
