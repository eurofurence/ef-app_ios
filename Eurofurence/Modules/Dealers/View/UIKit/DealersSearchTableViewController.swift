//
//  DealersSearchTableViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealersSearchTableViewController: UITableViewController {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        tableView.register(DealerComponentTableViewCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DealerComponentTableViewCell.self)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
        return header
    }

    // MARK: Private

    private class Header: UITableViewHeaderFooterView, DealerGroupHeader {

        static let identifier = "Header"

        func setDealersGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

}
