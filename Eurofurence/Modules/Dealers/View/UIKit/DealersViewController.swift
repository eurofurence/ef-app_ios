import UIKit

class DealersViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, DealersScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
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

    @IBAction func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(DealersSearchTableViewController.self)
        searchViewController?.onDidSelectSearchResultAtIndexPath = didSelectSearchResult
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange), for: .valueChanged)

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        tableView.register(DealerComponentTableViewCell.self)
        delegate?.dealersSceneDidLoad()
    }

    // MARK: UISearchControllerDelegate

    func presentSearchController(_ searchController: UISearchController) {
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
        refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.1)
    }

    func deselectDealer(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder) {
        tableController = TableController(numberOfDealersPerSection: numberOfDealersPerSection,
                                          sectionIndexTitles: sectionIndexTitles,
                                          binder: binder,
                                          onDidSelectRowAtIndexPath: didSelectDealer)
    }

    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder) {
        searchViewController?.bindSearchResults(numberOfDealersPerSection: numberOfDealersPerSection,
                                                sectionIndexTitles: sectionIndexTitles,
                                                using: binder)
    }

    // MARK: Private

    @objc private func refreshControlValueDidChange() {
        delegate?.dealersSceneDidPerformRefreshAction()
    }

    private func didSelectDealer(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealer(at: indexPath)
    }

    private func didSelectSearchResult(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealerSearchResult(at: indexPath)
    }

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
        private let onDidSelectRowAtIndexPath: (IndexPath) -> Void

        init(numberOfDealersPerSection: [Int],
             sectionIndexTitles: [String],
             binder: DealersBinder,
             onDidSelectRowAtIndexPath: @escaping (IndexPath) -> Void) {
            self.numberOfDealersPerSection = numberOfDealersPerSection
            self.sectionIndexTitles = sectionIndexTitles
            self.binder = binder
            self.onDidSelectRowAtIndexPath = onDidSelectRowAtIndexPath
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

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath(indexPath)
        }

    }

}
