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
    @IBOutlet weak var daysCollectionView: UICollectionView!

    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
        }
    }

    private var daysController: DaysController? {
        didSet {
            daysCollectionView.dataSource = daysController
            daysCollectionView.delegate = daysController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage(named: "Transparent Pixel")
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
//        daysView.bind(numberOfDays: numberOfDays, using: binder)
        daysController = DaysController(numberOfDays: numberOfDays, binder: binder)
    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection, binder: binder)
    }

    func selectDay(at index: Int) {
//        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
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

    private class DaysController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let numberOfDays: Int
        private let binder: ScheduleDaysBinder

        init(numberOfDays: Int, binder: ScheduleDaysBinder) {
            self.numberOfDays = numberOfDays
            self.binder = binder
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfDays
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(ScheduleDayCollectionViewCell.self, for: indexPath)
            binder.bind(cell, forDayAt: indexPath.item)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            var safeAreaInsets: UIEdgeInsets = .zero
            if #available(iOS 11.0, *) {
                safeAreaInsets = collectionView.safeAreaInsets
            }

            return UIEdgeInsets(top: 0, left: safeAreaInsets.left, bottom: 0, right: safeAreaInsets.right)
        }

    }

}
