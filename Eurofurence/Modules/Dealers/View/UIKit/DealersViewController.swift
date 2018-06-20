//
//  DealersViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealersViewController: UIViewController, UISearchControllerDelegate, DealersScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
        }
    }

    private var searchViewController: DealersSearchTableViewController?
    private var searchController: UISearchController?

    // MARK: IBActions

    @IBAction func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(DealersSearchTableViewController.self)
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController?.delegate = self

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        tableView.register(DealerComponentTableViewCell.self)
        delegate?.dealersSceneDidLoad()
    }

    // MARK: UISearchControllerDelegate

    func presentSearchController(_ searchController: UISearchController) {
        present(searchController, animated: true)
    }

    // MARK: DealersScene

    private var delegate: DealersSceneDelegate?
    func setDelegate(_ delegate: DealersSceneDelegate) {
        self.delegate = delegate
    }

    func setDealersTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder) {
        tableController = TableController(numberOfDealersPerSection: numberOfDealersPerSection,
                                          sectionIndexTitles: sectionIndexTitles,
                                          binder: binder)
    }

    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder) {

    }

    // MARK: Private

    private class Header: UITableViewHeaderFooterView, DealerGroupHeader {

        static let identifier = "Header"

        func setDealersGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfDealersPerSection: [Int]
        private let sectionIndexTitles: [String]
        private let binder: DealersBinder

        init(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], binder: DealersBinder) {
            self.numberOfDealersPerSection = numberOfDealersPerSection
            self.sectionIndexTitles = sectionIndexTitles
            self.binder = binder
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfDealersPerSection.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfDealersPerSection[section]
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(DealerComponentTableViewCell.self)
            binder.bind(cell, toDealerAt: indexPath)
            return cell
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
            binder.bind(header, toDealerGroupAt: section)
            return header
        }

        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return sectionIndexTitles
        }

    }

}
