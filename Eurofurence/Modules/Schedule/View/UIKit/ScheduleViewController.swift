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
            tableView.reloadData()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        daysCollectionView.collectionViewLayout.invalidateLayout()
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
        daysController = DaysController(numberOfDays: numberOfDays, binder: binder, onDaySelected: dayPickerDidSelectDay)
    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection,
                                          binder: binder,
                                          onDidSelectRow: scheduleTableViewDidSelectRow)
    }

    func selectDay(at index: Int) {
        daysCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredHorizontally)
    }

    func deselectEvent(at indexPath: IndexPath) {

    }

    // MARK: Private

    private func scheduleTableViewDidSelectRow(_ indexPath: IndexPath) {
        delegate?.scheduleSceneDidSelectEvent(at: indexPath)
    }

    private func dayPickerDidSelectDay(_ index: Int) {
        delegate?.scheduleSceneDidSelectDay(at: index)
    }

    private class Header: UITableViewHeaderFooterView, ScheduleEventGroupHeader {

        static let identifier = "Header"

        func setEventGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfItemsPerSection: [Int]
        private let binder: ScheduleSceneBinder
        private let onDidSelectRow: (IndexPath) -> Void

        init(numberOfItemsPerSection: [Int], binder: ScheduleSceneBinder, onDidSelectRow: @escaping (IndexPath) -> Void) {
            self.numberOfItemsPerSection = numberOfItemsPerSection
            self.binder = binder
            self.onDidSelectRow = onDidSelectRow
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

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRow(indexPath)
        }

    }

    private class DaysController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let numberOfDays: Int
        private let binder: ScheduleDaysBinder
        private let onDaySelected: (Int) -> Void

        init(numberOfDays: Int, binder: ScheduleDaysBinder, onDaySelected: @escaping (Int) -> Void) {
            self.numberOfDays = numberOfDays
            self.binder = binder
            self.onDaySelected = onDaySelected
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfDays
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(ScheduleDayCollectionViewCell.self, for: indexPath)
            binder.bind(cell, forDayAt: indexPath.item)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth: CGFloat
            if #available(iOS 11.0, *) {
                availableWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            } else {
                availableWidth = collectionView.bounds.width
            }

            let sensibleMinimumWidth: CGFloat = 64
            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
            let itemWidth = max(sensibleMinimumWidth, availableWidth / CGFloat(numberOfItems))

            return CGSize(width: itemWidth, height: collectionView.bounds.height)
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            onDaySelected(indexPath.item)
        }

    }

}
