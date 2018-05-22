//
//  EventDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, EventDetailScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.eventDetailSceneDidLoad()
    }

    // MARK: EventDetailScene

    private var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(using binder: EventDetailBinder) {
        tableController = TableController(tableView: tableView, binder: binder)
    }

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource, EventDetailComponentFactory {

        private let tableView: UITableView
        private let binder: EventDetailBinder

        init(tableView: UITableView, binder: EventDetailBinder) {
            self.tableView = tableView
            self.binder = binder
            super.init()

            tableView.dataSource = self
        }

        // MARK: EventDetailComponentFactory

        func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailSummaryTableViewCell.self)
            block(cell)
            return cell
        }

        func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> UITableViewCell {
            return UITableViewCell()
        }

        // MARK: UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

    }

}
