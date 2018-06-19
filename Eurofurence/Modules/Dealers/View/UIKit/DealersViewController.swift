//
//  DealersViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealersViewController: UIViewController, DealersScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DealerComponentTableViewCell.self)
        delegate?.dealersSceneDidLoad()
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

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource {

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

        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return sectionIndexTitles
        }

    }

}
