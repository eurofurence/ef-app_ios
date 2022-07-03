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
        
        let cellName = String(describing: EventTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: .module)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
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
    
    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let actions = binder?.eventActionsForComponent(at: indexPath) else { return nil }
        guard let sender = tableView.cellForRow(at: indexPath) else { return nil }
        
        let menuActions = actions.map { $0.makeUIAction(sender: sender) }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) in
            UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: menuActions)
        }
    }

}
