import ComponentBase
import UIKit

class KnowledgeDetailViewController: UIViewController, KnowledgeDetailScene {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    private lazy var tableController = TableController(tableView: self.tableView)
    
    // MARK: IBActions
    
    @IBAction private func shareEntry(_ sender: UIBarButtonItem) {
        delegate?.knowledgeDetailSceneShareButtonTapped(sender)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        Theme.global.apply(to: tableView)
        tableView.dataSource = tableController
        tableView.delegate = tableController
        delegate?.knowledgeDetailSceneDidLoad()
    }

    // MARK: KnowledgeDetailScene

    private var delegate: KnowledgeDetailSceneDelegate?
    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setKnowledgeDetailTitle(_ title: String) {
        super.title = title
    }

    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString) {
        let contentsItem = ContentsItem(contents: contents)
        tableController.add(contentsItem)
    }

    func presentLinks(count: Int, using binder: LinksBinder) {
        let linkItems = (0..<count).map({ LinkItem(binder: binder, index: $0, delegate: delegate) })
        linkItems.forEach(tableController.add)
    }

    func bindImages(count: Int, using binder: KnowledgEntryImagesBinder) {
        (0..<count).map({ ImageItem(binder: binder, index: $0) }).forEach(tableController.add)
    }

    // MARK: Private

    private struct ContentsItem: TableViewDataItem {

        var contents: NSAttributedString

        func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeDetailContentsTableViewCell.self)
            cell.configure(contents)
            return cell
        }

    }

    private struct ImageItem: TableViewDataItem {

        var binder: KnowledgEntryImagesBinder
        var index: Int
        
        func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeDetailImageTableViewCell.self)
            binder.bind(cell, at: index)
            cell.hideSeperator()
            
            return cell
        }

    }

    private struct LinkItem: TableViewDataItem {

        var binder: LinksBinder
        var index: Int
        var delegate: KnowledgeDetailSceneDelegate?

        func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(LinkTableViewCell.self)
            binder.bind(cell, at: index)
            return cell
        }

    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let tableView: UITableView
        private(set) var items = [TableViewDataItem]()

        init(tableView: UITableView) {
            self.tableView = tableView
        }

        func add(_ item: TableViewDataItem) {
            items.append(item)
            tableView.reloadData()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return items[indexPath.row].makeCell(for: tableView, at: indexPath)
        }

    }

}

private protocol TableViewDataItem {

    func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

}
