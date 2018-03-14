//
//  KnowledgeDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeDetailViewController: UIViewController, KnowledgeDetailScene {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!
    private lazy var tableViewDataSource = DataSource(tableView: self.tableView)

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tableViewDataSource
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
        tableViewDataSource.add(contentsItem)
    }

    func presentLinks(count: Int, using binder: LinksBinder) {
        let linksItem = LinksItem(count: count, binder: binder)
        tableViewDataSource.add(linksItem)
    }

    func deselectLink(at index: Int) {

    }

    // MARK: Private

    private struct ContentsItem: TableViewDataItem {

        var contents: NSAttributedString

        func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeDetailContentsTableViewCell.self)
            cell.textView.attributedText = contents

            return cell
        }

    }

    private struct LinksItem: TableViewDataItem {

        var count: Int
        var binder: LinksBinder

        func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeDetailLinksTableViewCell.self)
            cell.showLinks(count: count, binder: binder)

            return cell
        }

    }

    private class DataSource: NSObject, UITableViewDataSource {

        private let tableView: UITableView
        private var items = [TableViewDataItem]()

        init(tableView: UITableView) {
            self.tableView = tableView
        }

        func add(_ item: TableViewDataItem) {
            items.append(item)
            tableView.reloadData()
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return items.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return items[indexPath.section].makeCell(for: tableView, at: indexPath)
        }

    }

}

private protocol TableViewDataItem {

    func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

}
