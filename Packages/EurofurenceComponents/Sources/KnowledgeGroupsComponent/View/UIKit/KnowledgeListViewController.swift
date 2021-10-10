import ComponentBase
import UIKit

public class KnowledgeListViewController: UIViewController, KnowledgeListScene {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: KnowledgeListScene

    private var delegate: KnowledgeListSceneDelegate?
    public func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
        self.delegate = delegate
    }

    public func setKnowledgeListTitle(_ title: String) {
        navigationItem.title = title
    }

    public func setKnowledgeListShortTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    public func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    public func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    private lazy var tableViewRenderer = TableViewDataSource()
    public func prepareToDisplayKnowledgeGroups(numberOfGroups: Int, binder: KnowledgeListBinder) {
        tableViewRenderer.entryCounts = numberOfGroups
        tableViewRenderer.binder = binder

        tableView.reloadData()
    }

    public func deselectKnowledgeEntry(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Overrides

    override public func viewDidLoad() {
        super.viewDidLoad()

        Theme.global.apply(to: tableView)
        tableViewRenderer.onDidSelectRowAtIndexPath = didSelectRow
        tableView.dataSource = tableViewRenderer
        tableView.delegate = tableViewRenderer
        tableView.estimatedSectionHeaderHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        delegate?.knowledgeListSceneDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectSelectedRow()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.adjustScrollIndicatorInsetsForSafeAreaCompensation()
    }

    // MARK: Private

    private func didSelectRow(at indexPath: IndexPath) {
        delegate?.knowledgeListSceneDidSelectKnowledgeGroup(at: indexPath.row)
    }

    private class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

        var entryCounts = 0
        var binder: KnowledgeListBinder?
        var onDidSelectRowAtIndexPath: ((IndexPath) -> Void)?

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return entryCounts
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeListSectionHeaderTableViewCell.self)
            binder?.bind(cell, toGroupAt: indexPath.row)

            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath?(indexPath)
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }

        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }

    }

}
