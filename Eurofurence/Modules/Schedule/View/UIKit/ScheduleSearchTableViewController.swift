//
//  ScheduleSearchTableViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleSearchTableViewController: UITableViewController {

    // MARK: Search Convenience Collab

    private var numberOfItemsPerSection: [Int] = []
    private var binder: ScheduleSceneSearchResultsBinder?
    var onDidSelectSearchResultAtIndexPath: ((IndexPath) -> Void)?

    func updateSearchResults(numberOfItemsPerSection: [Int], binder: ScheduleSceneSearchResultsBinder) {
        self.numberOfItemsPerSection = numberOfItemsPerSection
        self.binder = binder
        tableView.reloadData()
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        tableView.register(EventTableViewCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfItemsPerSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsPerSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(EventTableViewCell.self)
        binder?.bind(cell, forSearchResultAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
        binder?.bind(header, forSearchResultGroupAt: section)
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectSearchResultAtIndexPath?(indexPath)
    }

    // MARK: Private

    private class Header: UITableViewHeaderFooterView, ScheduleEventGroupHeader {

        static let identifier = "Header"

        func setEventGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

}
