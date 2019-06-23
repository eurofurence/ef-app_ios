import UIKit

class DealersViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, DealersScene {

    // MARK: Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationBarExtension: NavigationBarViewExtensionContainer!
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
        
        if #available(iOS 11.0, *) {
            extendedLayoutIncludesOpaqueBars = true
        } else {
            extendedLayoutIncludesOpaqueBars = false
        }
        
        delegate?.dealersSceneDidLoad()
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.rightBarButtonItem = nil
            Theme.performUnsafeSearchControllerStyling(searchController: searchController)
        }
        
        self.searchController = searchController
    }

    // MARK: UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        present(searchController, animated: true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationBarExtension.isHidden = true
        
        if #available(iOS 11.0, *) { return }
        adjustTableViewContentInsetsForiOS10LayoutProblems()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        navigationBarExtension.isHidden = false
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
    
    private func adjustTableViewContentInsetsForiOS10LayoutProblems() {
        tableView.contentInset = .zero
    }

    @objc private func refreshControlValueDidChange() {
        delegate?.dealersSceneDidPerformRefreshAction()
    }

    private func didSelectDealer(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealer(at: indexPath)
    }

    private func didSelectSearchResult(at indexPath: IndexPath) {
        delegate?.dealersSceneDidSelectDealerSearchResult(at: indexPath)
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

    }

}

extension ConventionBrandedTableViewHeaderFooterView: DealerGroupHeader {
    
    func setDealersGroupTitle(_ title: String) {
        textLabel?.text = title
    }
    
}
