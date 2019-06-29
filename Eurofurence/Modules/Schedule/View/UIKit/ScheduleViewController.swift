import UIKit

class ScheduleViewController: UIViewController,
                              UISearchControllerDelegate,
                              UISearchResultsUpdating,
                              UISearchBarDelegate,
                              DaysHorizontalPickerViewDelegate,
                              ScheduleScene {

    // MARK: Properties

    @IBOutlet private weak var daysPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var daysHorizontalPickerView: DaysHorizontalPickerView! {
        didSet {
            daysHorizontalPickerView.delegate = self
        }
    }
    
    private let refreshControl = UIRefreshControl(frame: .zero)
    private lazy var navigationBarShadowDelegate = HideNavigationBarShadowForSpecificViewControllerDelegate(viewControllerToHideNavigationBarShadow: self)

    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
            tableView.reloadData()
        }
    }

    private var searchViewController: ScheduleSearchTableViewController?
    private var searchController: UISearchController?

    @IBAction private func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(ScheduleSearchTableViewController.self)
        searchViewController?.onDidSelectSearchResultAtIndexPath = didSelectSearchResult
        
        var insets = tableView.contentInset
        insets.top = daysHorizontalPickerView.bounds.height
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        if #available(iOS 11.0, *) {
            extendedLayoutIncludesOpaqueBars = true
        } else {
            extendedLayoutIncludesOpaqueBars = false
        }
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)
        
        prepareSearchController()

        navigationController?.delegate = navigationBarShadowDelegate
        tableView.register(EventTableViewCell.self)
        tableView.registerConventionBrandedHeader()
        delegate?.scheduleSceneDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layoutDaysCollectionView()
        tableView?.setEditing(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.adjustScrollIndicatorInsetsForSafeAreaCompensation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutDaysCollectionView()
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = [.allEvents, .favourites]
        searchController.searchResultsUpdater = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.rightBarButtonItem = nil
            Theme.performUnsafeSearchControllerStyling(searchController: searchController)
        }
        
        self.searchController = searchController
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
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if #available(iOS 11.0, *) { return }
        adjustTableViewContentInsetsForiOS10LayoutProblems()
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
        refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.1)
    }

    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        daysHorizontalPickerView.bind(numberOfDays: numberOfDays, using: binder)
    }

    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection,
                                          binder: binder,
                                          onDidSelectRow: scheduleTableViewDidSelectRow,
                                          onTableViewDidScroll: tableViewDidScroll,
                                          onDidEndDragging: scrollViewDidEndDragging)
    }

    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        searchViewController?.updateSearchResults(numberOfItemsPerSection: numberOfItemsPerSection, binder: binder)
    }

    func showSearchResults() {
        searchController?.searchResultsController?.view.isHidden = false
    }

    func hideSearchResults() {
        searchController?.searchResultsController?.view.isHidden = true
    }

    func selectDay(at index: Int) {
        daysHorizontalPickerView.selectDay(at: index)
    }

    func deselectEvent(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func deselectSearchResult(at indexPath: IndexPath) {
        searchViewController?.deselectSearchResult(at: indexPath)
    }
    
    // MARK: DaysHorizontalPickerViewDelegate
    
    func daysHorizontalPickerView(_ pickerView: DaysHorizontalPickerView, didSelectDayAt index: Int) {
        delegate?.scheduleSceneDidSelectDay(at: index)
    }

    // MARK: Private
    
    private func adjustTableViewContentInsetsForiOS10LayoutProblems() {
        var insets = tableView.contentInset
        var topInsets = daysHorizontalPickerView.bounds.height
        if let navigationBar = navigationController?.navigationBar {
            topInsets += navigationBar.bounds.height
        }
        
        insets.top = topInsets
        tableView.contentInset = insets
    }

    @objc private func refreshControlDidChangeValue() {
        if tableView.isDragging == false {
            notifyDidPerformRefreshAction()
        }
    }
    
    private func scrollViewDidEndDragging() {
        if refreshControl.isRefreshing {
            notifyDidPerformRefreshAction()
        }
    }
    
    private func notifyDidPerformRefreshAction() {
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

    private func layoutDaysCollectionView() {
        daysHorizontalPickerView?.forceLayout()
    }

    private func resetSearchSceneForSearchingAllEvents() {
        searchController?.searchBar.selectedScopeButtonIndex = 0
        delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()
    }
    
    private func tableViewDidScroll(to offset: CGPoint) {
        if #available(iOS 11.0, *) {
            guard offset.y < 0 else { return }
            
            let safeAreaApplyingScrollViewContentInsets = view.safeAreaLayoutGuide.layoutFrame.origin.y + tableView.contentInset.top
            let distance = max(0, abs(offset.y) - safeAreaApplyingScrollViewContentInsets)
            daysPickerTopConstraint.constant = distance
        }
    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfItemsPerSection: [Int]
        private let binder: ScheduleSceneBinder
        private let onDidSelectRow: (IndexPath) -> Void
        private let onTableViewDidScroll: (CGPoint) -> Void
        private let onDidEndDragging: () -> Void

        init(numberOfItemsPerSection: [Int],
             binder: ScheduleSceneBinder,
             onDidSelectRow: @escaping (IndexPath) -> Void,
             onTableViewDidScroll: @escaping (CGPoint) -> Void,
             onDidEndDragging: @escaping () -> Void) {
            self.numberOfItemsPerSection = numberOfItemsPerSection
            self.binder = binder
            self.onDidSelectRow = onDidSelectRow
            self.onTableViewDidScroll = onTableViewDidScroll
            self.onDidEndDragging = onDidEndDragging
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfItemsPerSection.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfItemsPerSection[section]
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueConventionBrandedHeader()
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

        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let action = binder.eventActionForComponent(at: indexPath)
            let rowAction: UITableViewRowAction = UITableViewRowAction(style: .normal, title: action.title, handler: { (_, _) in
                action.run()
            })

            rowAction.backgroundColor = .pantone330U

            return [rowAction]
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onTableViewDidScroll(scrollView.contentOffset)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            onDidEndDragging()
        }

    }

}

extension ConventionBrandedTableViewHeaderFooterView: ScheduleEventGroupHeader {
    
    func setEventGroupTitle(_ title: String) {
        textLabel?.text = title
    }
    
}
