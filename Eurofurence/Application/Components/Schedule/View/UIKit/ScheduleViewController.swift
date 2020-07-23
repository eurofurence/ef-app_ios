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
        
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 13.0, *) {
            if let navigationBarAppearance = navigationController?.navigationBar.standardAppearance {
                navigationBarAppearance.shadowColor = .navigationBar
                navigationController?.navigationBar.standardAppearance = navigationBarAppearance
                navigationController?.navigationBar.compactAppearance = navigationBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            }
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
        
        tableView.deselectSelectedRow()
        layoutDaysCollectionView()
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = [.allEvents, .favourites]
        searchController.searchResultsUpdater = self
        Theme.performUnsafeSearchControllerStyling(searchController: searchController)
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = nil
        
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
        ensureScrolledToTopToAvoidLargeTitlesPresentationIssue()
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
    
    // MARK: DaysHorizontalPickerViewDelegate
    
    func daysHorizontalPickerView(_ pickerView: DaysHorizontalPickerView, didSelectDayAt index: Int) {
        delegate?.scheduleSceneDidSelectDay(at: index)
        scrollToTableViewTop()
    }

    // MARK: Private

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
        guard offset.y < 0 else { return }
        
        let safeAreaApplyingScrollViewContentInsets = view.safeAreaLayoutGuide.layoutFrame.origin.y + tableView.contentInset.top
        let distance = max(0, abs(offset.y) - safeAreaApplyingScrollViewContentInsets)
        daysPickerTopConstraint.constant = distance
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
            guard let sender = tableView.cellForRow(at: indexPath) else { return nil }
            let actions = binder.eventActionsForComponent(at: indexPath)
            
            return actions.map { (action) in
                UITableViewRowAction(style: .normal, title: action.title, handler: { (_, _) in
                    action.run(sender)
                })
            }
        }
        
        @available(iOS 13.0, *)
        func tableView(
            _ tableView: UITableView,
            contextMenuConfigurationForRowAt indexPath: IndexPath,
            point: CGPoint
        ) -> UIContextMenuConfiguration? {
            guard let sender = tableView.cellForRow(at: indexPath) else { return nil }
            let actions = binder.eventActionsForComponent(at: indexPath)
            
            let menuActions = actions.map { $0.makeUIAction(sender: sender) }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) in
                UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: menuActions)
            }
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
