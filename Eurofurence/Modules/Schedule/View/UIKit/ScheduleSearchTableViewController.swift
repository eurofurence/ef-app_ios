import UIKit

class ScheduleSearchTableViewController: UITableViewController {

    // MARK: Search Convenience Collab

    private var numberOfItemsPerSection: [Int] = []
    private var binder: ScheduleSceneBinder?
    var onDidSelectSearchResultAtIndexPath: ((IndexPath) -> Void)?

    func updateSearchResults(numberOfItemsPerSection: [Int], binder: ScheduleSceneBinder) {
        self.numberOfItemsPerSection = numberOfItemsPerSection
        self.binder = binder
        tableView.reloadData()
    }

    func deselectSearchResult(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerConventionBrandedHeader()
        tableView.register(EventTableViewCell.self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.setEditing(false, animated: false)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfItemsPerSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsPerSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(EventTableViewCell.self)
        binder?.bind(cell, forEventAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueConventionBrandedHeader()
        binder?.bind(header, forGroupAt: section)
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectSearchResultAtIndexPath?(indexPath)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let action = binder?.eventActionForComponent(at: indexPath) else { return nil }
        let rowAction: UITableViewRowAction = UITableViewRowAction(style: .normal, title: action.title, handler: { (_, _) in
            action.run()
        })

        rowAction.backgroundColor = .pantone330U

        return [rowAction]
    }

}
