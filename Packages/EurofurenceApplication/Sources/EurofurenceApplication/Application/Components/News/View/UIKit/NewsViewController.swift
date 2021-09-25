import ComponentBase
import ScheduleComponent
import UIKit.UIViewController

class NewsViewController: UIViewController, NewsScene {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl(frame: .zero)

    // MARK: Properties

    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Theme.global.apply(to: tableView)

        refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(AnnouncementTableViewCell.self)
        tableView.register(EventTableViewCell.self)
        tableView.registerConventionBrandedHeader()
        delegate?.newsSceneDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectSelectedRow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.adjustScrollIndicatorInsetsForSafeAreaCompensation()
    }

    // MARK: NewsScene

    var delegate: NewsSceneDelegate?

    func showNewsTitle(_ title: String) {
        super.title = title
    }

    func showRefreshIndicator() {
        refreshControl.beginRefreshing()
    }

    func hideRefreshIndicator() {
        refreshControl.endRefreshing()
    }

    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder) {
        tableController = TableController(
            tableView: tableView,
            numberOfItemsPerComponent: numberOfItemsPerComponent,
            binder: binder
        )
        
        tableController?.onDidSelectRowAtIndexPath = tableViewDidSelectRow
        tableController?.onDidEndDragging = scrollViewDidEndDragging
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.reloadData()
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
        delegate?.newsSceneDidPerformRefreshAction()
    }

    private func tableViewDidSelectRow(at indexPath: IndexPath) {
        delegate?.newsSceneDidSelectComponent(at: indexPath)
    }

    private class TableController: NSObject, NewsItemComponentFactory, UITableViewDataSource, UITableViewDelegate {

        private let tableView: UITableView
        private let numberOfItemsPerComponent: [Int]
        private let binder: NewsComponentsBinder
        var onDidSelectRowAtIndexPath: ((IndexPath) -> Void)?
        var onDidEndDragging: (() -> Void)?

        init(tableView: UITableView, numberOfItemsPerComponent: [Int], binder: NewsComponentsBinder) {
            self.tableView = tableView
            self.numberOfItemsPerComponent = numberOfItemsPerComponent
            self.binder = binder
        }

        // MARK: NewsComponentFactory

        func makeConventionCountdownComponent(
            configuringUsing block: (ConventionCountdownComponent) -> Void
        ) -> UITableViewCell {
            return manufacture(NewsConventionCountdownTableViewCell.self, configuration: block)
        }

        func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> UITableViewCell {
            return manufacture(NewsUserWidgetTableViewCell.self, configuration: block)
        }

        func makeAnnouncementComponent(configuringUsing block: (AnnouncementItemComponent) -> Void) -> UITableViewCell {
            return manufacture(AnnouncementTableViewCell.self, configuration: block)
        }

        func makeAllAnnouncementsComponent(
            configuringUsing block: (AllAnnouncementsComponent) -> Void
        ) -> UITableViewCell {
            return manufacture(ViewAllAnnouncementsTableViewCell.self, configuration: block)
        }

        func makeEventComponent(configuringUsing block: (ScheduleEventComponent) -> Void) -> UITableViewCell {
            return manufacture(EventTableViewCell.self, configuration: block)
        }

        private func manufacture<T>(_ cellType: T.Type, configuration: (T) -> Void) -> T where T: UITableViewCell {
            let cell = tableView.dequeue(cellType)
            configuration(cell)
            return cell
        }

        // MARK: UITableViewDataSource

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfItemsPerComponent.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfItemsPerComponent[section]
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

        // MARK: UITableViewDelegate

        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 1
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueConventionBrandedHeader()
            binder.bindTitleForSection(at: section, scene: header)
            return header
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            onDidEndDragging?()
        }

        // MARK: Functions

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath?(indexPath)
        }

    }

}

extension ConventionBrandedTableViewHeaderFooterView: NewsComponentHeaderScene {
    
    public func setComponentTitle(_ title: String?) {
        textLabel?.text = title
    }
    
}
