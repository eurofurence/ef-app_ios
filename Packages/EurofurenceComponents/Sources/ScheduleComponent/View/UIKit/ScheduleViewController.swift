import ComponentBase
import UIKit

public class ScheduleViewController: UIViewController,
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
    
    private lazy var showFavouritesOnlyBarButtonItem: UIBarButtonItem = {
        let showFavouritesOnlyBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.circle"),
            style: .plain,
            target: self,
            action: #selector(favouritesToggleButtonTapped(_:))
        )
        
        showFavouritesOnlyBarButtonItem.accessibilityLabel = "Favourites Only"
        showFavouritesOnlyBarButtonItem.tintColor = .white
        
        return showFavouritesOnlyBarButtonItem
    }()
    
    private lazy var showAllEventsBarButtonItem: UIBarButtonItem = {
        let showAllEventsBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(favouritesToggleButtonTapped(_:))
        )
        
        showAllEventsBarButtonItem.accessibilityLabel = "All Events"
        showAllEventsBarButtonItem.tintColor = .white
        
        return showAllEventsBarButtonItem
    }()
    
    @objc private func favouritesToggleButtonTapped(_ sender: UIButton) {
        delegate?.scheduleSceneDidToggleFavouriteFilterState()
    }
    
    private let refreshControl = UIRefreshControl(frame: .zero)
    
    private var tableController: TableController? {
        didSet {
            UIView.transition(with: tableView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
                tableView.dataSource = tableController
                tableView.delegate = tableController
                tableView.reloadData()
            }
        }
    }
    
    private var searchViewController: ScheduleSearchTableViewController?
    private var searchController: UISearchController?
    
    @IBAction private func openSearch(_ sender: Any) {
        searchController?.isActive = true
    }
    
    // MARK: Overrides
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        searchViewController = storyboard?.instantiate(ScheduleSearchTableViewController.self)
        searchViewController?.onDidSelectSearchResultAtIndexPath = didSelectSearchResult
        
        var insets = tableView.contentInset
        insets.top = daysHorizontalPickerView.bounds.height
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        extendedLayoutIncludesOpaqueBars = true
        
        Theme.global.apply(to: tableView)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)
        
        prepareSearchController()
        
        let cellName = String(describing: EventTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: .module)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableView.registerConventionBrandedHeader()
        delegate?.scheduleSceneDidLoad()
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView?.setEditing(false, animated: false)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.adjustScrollIndicatorInsetsForSafeAreaCompensation()
    }
    
    private func prepareSearchController() {
        let allEventsScopeTitle = NSLocalizedString(
            "AllEvents",
            bundle: .module,
            comment: "Title for the button used under the events search bar to search all events"
        )
        
        let favouritesScopeTitle = NSLocalizedString(
            "Favourites",
            bundle: .module,
            comment: "Title for the button used under the events search bar to search only the user's favourites"
        )
        
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = [allEventsScopeTitle, favouritesScopeTitle]
        searchController.searchResultsUpdater = self
        Theme.global.apply(to: searchController)
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = nil
        
        self.searchController = searchController
    }
    
    // MARK: UISearchBarDelegate
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()
            
        default:
            delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()
        }
    }
    
    // MARK: UISearchControllerDelegate
    
    public func presentSearchController(_ searchController: UISearchController) {
        resetSearchSceneForSearchingAllEvents()
        ensureScrolledToTopToAvoidLargeTitlesPresentationIssue()
        present(searchController, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            delegate?.scheduleSceneDidUpdateSearchQuery(query)
        }
    }
    
    // MARK: EventsScene
    
    private var delegate: ScheduleSceneDelegate?
    public func setDelegate(_ delegate: ScheduleSceneDelegate) {
        self.delegate = delegate
    }
    
    public func setScheduleTitle(_ title: String) {
        super.title = title
    }
    
    public func showRefreshIndicator() {
        refreshControl.beginRefreshing()
    }
    
    public func hideRefreshIndicator() {
        refreshControl.endRefreshing()
    }
    
    public func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        daysHorizontalPickerView.bind(numberOfDays: numberOfDays, using: binder)
    }
    
    public func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        tableController = TableController(numberOfItemsPerSection: numberOfItemsPerSection,
                                          binder: binder,
                                          onDidSelectRow: scheduleTableViewDidSelectRow,
                                          onTableViewDidScroll: tableViewDidScroll,
                                          onDidEndDragging: scrollViewDidEndDragging)
    }
    
    public func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        searchViewController?.updateSearchResults(numberOfItemsPerSection: numberOfItemsPerSection, binder: binder)
    }
    
    public func showSearchResults() {
        searchController?.searchResultsController?.view.isHidden = false
    }
    
    public func hideSearchResults() {
        searchController?.searchResultsController?.view.isHidden = true
    }
    
    public func selectDay(at index: Int) {
        daysHorizontalPickerView.selectDay(at: index)
    }
    
    public func showFilterToFavouritesButton() {
        navigationItem.setRightBarButton(showFavouritesOnlyBarButtonItem, animated: view.window != nil)
    }
    
    public func showFilterToAllEventsButton() {
        navigationItem.setRightBarButton(showAllEventsBarButtonItem, animated: view.window != nil)
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
    
    private func resetSearchSceneForSearchingAllEvents() {
        searchController?.searchBar.selectedScopeButtonIndex = 0
        delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()
    }
    
    private func tableViewDidScroll(to offset: CGPoint) {
        guard offset.y < 0 else { return }
        
        let safeAreaTop = view.safeAreaLayoutGuide.layoutFrame.origin.y
        let safeAreaApplyingScrollViewContentInsets = safeAreaTop + tableView.contentInset.top
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
        
        #if !targetEnvironment(macCatalyst)
        func tableView(
            _ tableView: UITableView,
            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
            guard let sender = tableView.cellForRow(at: indexPath) else { return nil }
            let actions = binder.eventActionsForComponent(at: indexPath)
            
            let contextualActions = actions.map { (action) in
                UIContextualAction(style: .normal, title: action.title) { (_, _, complete) in
                    action.run(sender)
                    complete(true)
                }
            }
            
            return UISwipeActionsConfiguration(actions: contextualActions)
        }
        #endif
        
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
    
    public func setEventGroupTitle(_ title: String) {
        textLabel?.text = title
    }
    
}
