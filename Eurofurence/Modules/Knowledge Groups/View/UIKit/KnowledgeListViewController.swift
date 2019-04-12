import UIKit

class KnowledgeListViewController: UIViewController, KnowledgeListScene {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: KnowledgeListScene

    private var delegate: KnowledgeListSceneDelegate?
    func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
        self.delegate = delegate
    }

    func setKnowledgeListTitle(_ title: String) {
        navigationItem.title = title
    }

    func setKnowledgeListShortTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    private lazy var tableViewRenderer = TableViewDataSource()
    func prepareToDisplayKnowledgeGroups(numberOfGroups: Int, binder: KnowledgeListBinder) {
        tableViewRenderer.entryCounts = numberOfGroups
        tableViewRenderer.binder = binder

        tableView.reloadData()
    }

    func deselectKnowledgeEntry(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRenderer.onDidSelectRowAtIndexPath = didSelectRow
        tableView.dataSource = tableViewRenderer
        tableView.delegate = tableViewRenderer
        tableView.estimatedSectionHeaderHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        delegate?.knowledgeListSceneDidLoad()
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
