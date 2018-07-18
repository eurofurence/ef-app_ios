//
//  ScheduleViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController,
                              UISearchControllerDelegate,
                              UISearchResultsUpdating,
                              UISearchBarDelegate,
                              ScheduleScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl(frame: .zero)
    private lazy var navigationBarShadowDelegate = HideNavigationBarShadowForSpecificViewControllerDelegate(viewControllerToHideNavigationBarShadow: self)

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

    private var searchViewController: ScheduleSearchTableViewController?
    private var searchController: UISearchController?

    @IBAction func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(ScheduleSearchTableViewController.self)
        searchViewController?.onDidSelectSearchResultAtIndexPath = didSelectSearchResult
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.scopeButtonTitles = [.allEvents, .favourites]
        searchController?.searchResultsUpdater = self

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)

        navigationController?.delegate = navigationBarShadowDelegate
        tableView.register(EventTableViewCell.self)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        delegate?.scheduleSceneDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layoutDaysCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutDaysCollectionView()
    }

    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()

        default:
            delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()
        }
    }

    // MARK: UISearchControllerDelegate

    func presentSearchController(_ searchController: UISearchController) {
        resetSearchSceneForSearchingAllEvents()
        present(searchController, animated: true)
    }

    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            delegate?.scheduleSceneDidUpdateSearchQuery(query)
        }
    }

    // MARK: EventsScene

    private var delegate: ScheduleSceneDelegate?
    func setDelegate(_ delegate: ScheduleSceneDelegate) {
        self.delegate = delegate
    }

    func setScheduleTitle(_ title: String) {
        super.title = title
    }

    func showRefreshIndicator() {
        refreshControl.beginRefreshing()
    }

    func hideRefreshIndicator() {
        refreshControl.endRefreshing()
    }

    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        daysController = DaysController(numberOfDays: numberOfDays, binder: binder, onDaySelected: dayPickerDidSelectDay)
    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection,
                                          binder: binder,
                                          onDidSelectRow: scheduleTableViewDidSelectRow)
    }

    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneSearchResultsBinder) {
        searchViewController?.updateSearchResults(numberOfItemsPerSection: numberOfItemsPerSection, binder: binder)
    }

    func showSearchResults() {
        searchController?.searchResultsController?.view.isHidden = false
    }

    func hideSearchResults() {
        searchController?.searchResultsController?.view.isHidden = true
    }

    func selectDay(at index: Int) {
        daysCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredHorizontally)
    }

    func deselectEvent(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func deselectSearchResult(at indexPath: IndexPath) {
        searchViewController?.deselectSearchResult(at: indexPath)
    }

    // MARK: Private

    @objc private func refreshControlDidChangeValue() {
        delegate?.scheduleSceneDidPerformRefreshAction()
    }

    private func searchQueryChanged(_ query: String) {
        delegate?.scheduleSceneDidUpdateSearchQuery(query)
    }

    private func didSelectSearchResult(at indexPath: IndexPath) {
        delegate?.scheduleSceneDidSelectSearchResult(at: indexPath)
    }

    private func scheduleTableViewDidSelectRow(_ indexPath: IndexPath) {
        delegate?.scheduleSceneDidSelectEvent(at: indexPath)
    }

    private func dayPickerDidSelectDay(_ index: Int) {
        delegate?.scheduleSceneDidSelectDay(at: index)
    }

    private func layoutDaysCollectionView() {
        daysCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    private func resetSearchSceneForSearchingAllEvents() {
        searchController?.searchBar.selectedScopeButtonIndex = 0
        delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()
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
