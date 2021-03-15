import EurofurenceComponentBase
import UIKit

class DealersViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, DealersScene {

    // MARK: Properties

    @IBOutlet private weak var tableView: UITableView!
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
        }
    }

    private let refreshControl = UIRefreshControl(frame: .zero)
    private var searchViewController: DealersSearchTableViewController?
    private var searchController: UISearchController?

    // MARK: IBActions

    @IBAction private func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }
    
    @IBAction private func unwindToDealers(unwindSegue: UIStoryboardSegue) {
        presentedViewController?.dismiss(animated: true)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(DealersSearchTableViewController.self)
        searchViewController?.onDidSelectSearchResultAtIndexPath = didSelectSearchResult

        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange), for: .valueChanged)

        tableView.refreshControl = refreshControl
        tableView.registerConventionBrandedHeader()
        tableView.register(DealerComponentTableViewCell.self)
        
        prepareSearchController()
        
        extendedLayoutIncludesOpaqueBars = true
        
        delegate?.dealersSceneDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectSelectedRow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.adjustScrollIndicatorInsetsForSafeAreaCompensation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowCategories",
              let navigationController = segue.destination as? UINavigationController,
              let filtersScene = navigationController.topViewController as? DealerCategoriesFilterScene else { return }
        
        delegate?.dealersSceneDidRevealCategoryFiltersScene(filtersScene)
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        Theme.performUnsafeSearchControllerStyling(searchController: searchController)
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = nil
        
        self.searchController = searchController
    }

    // MARK: UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        ensureScrolledToTopToAvoidLargeTitlesPresentationIssue()
        present(searchController, animated: true)
    }

    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            delegate?.dealersSceneDidChangeSearchQuery(to: query)
        }
    }

    // MARK: DealersScene

    private var delegate: DealersSceneDelegate?
    func setDelegate(_ delegate: DealersSceneDelegate) {
        self.delegate = delegate
    }

    func setDealersTitle(_ title: String) {
        super.title = title
    }

    func showRefreshIndicator() {
        refreshControl.beginRefreshing()
    }

    func hideRefreshIndicator() {
        refreshControl.endRefreshing()
    }

    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder) {
        tableController = TableController(numberOfDealersPerSection: numberOfDealersPerSection,
                                          sectionIndexTitles: sectionIndexTitles,
                                          binder: binder,
                                          onDidSelectRowAtIndexPath: didSelectDealer,
                                          onDidEndDragging: scrollViewDidEndDragging)
        tableView.reloadData()
    }

    func bindSearchResults(
        numberOfDealersPerSection: [Int],
        sectionIndexTitles: [String],
        using binder: DealersSearchResultsBinder
    ) {
        searchViewController?.bindSearchResults(
            numberOfDealersPerSection: numberOfDealersPerSection,
            sectionIndexTitles: sectionIndexTitles,
            using: binder
        )
    }

    // MARK: Private

    @objc private func refreshControlValueDidChange() {
        if tableView.isDragging == false {        
            delegate?.dealersSceneDidPerformRefreshAction()
        }
    }
    
    private func scrollViewDidEndDragging() {
        if refreshControl.isRefreshing {
            delegate?.dealersSceneDidPerformRefreshAction()
        }
    }

    private func didSelectDealer(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealer(at: indexPath)
    }

    private func didSelectSearchResult(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealerSearchResult(at: indexPath)
    }
    
    private func scrollToTableViewTop() {
        guard tableViewHasData() else { return }
        
        let firstIndex = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: firstIndex, at: .top, animated: true)
    }
    
    private func tableViewHasData() -> Bool {
        return tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: 0) > 0
    }
    
    private func ensureScrolledToTopToAvoidLargeTitlesPresentationIssue() {
        scrollToTableViewTop()
    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfDealersPerSection: [Int]
        private let sectionIndexTitles: [String]
        private let binder: DealersBinder
        private let onDidSelectRowAtIndexPath: (IndexPath) -> Void
        private let onDidEndDragging: () -> Void

        init(numberOfDealersPerSection: [Int],
             sectionIndexTitles: [String],
             binder: DealersBinder,
             onDidSelectRowAtIndexPath: @escaping (IndexPath) -> Void,
             onDidEndDragging: @escaping () -> Void) {
            self.numberOfDealersPerSection = numberOfDealersPerSection
            self.sectionIndexTitles = sectionIndexTitles
            self.binder = binder
            self.onDidSelectRowAtIndexPath = onDidSelectRowAtIndexPath
            self.onDidEndDragging = onDidEndDragging
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
            let header = tableView.dequeueConventionBrandedHeader()
            
            binder.bind(header, toDealerGroupAt: section)
            return header
        }

        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return sectionIndexTitles
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath(indexPath)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            onDidEndDragging()
        }

    }

}

extension ConventionBrandedTableViewHeaderFooterView: DealerGroupHeader {
    
    public func setDealersGroupTitle(_ title: String) {
        textLabel?.text = title
    }
    
}
