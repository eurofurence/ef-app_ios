//
//  KnowledgeDetailLinksTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeDetailLinksTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Functions

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = tableViewDataSource
    }

    func showLinks(count: Int, binder: LinksBinder) {
        tableViewDataSource.showLinks(count: count, binder: binder)
        tableView.reloadData()
    }

    // MARK: Private

    private lazy var tableViewDataSource = DataSource()

    private class DataSource: NSObject, UITableViewDataSource {

        private var items = 0
        private var binder: LinksBinder?

        func showLinks(count: Int, binder: LinksBinder) {
            items = count
            self.binder = binder
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(LinkTableViewCell.self)
            binder?.bind(cell, at: indexPath.item)

            return cell
        }

    }

}
