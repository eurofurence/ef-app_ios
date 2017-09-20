//
//  MessagesViewControllerV2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class MessagesViewControllerV2: UIViewController,
                                UITableViewDelegate,
                                MessagesScene {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMessagesPlaceholder: UIView!
    let refreshIndicator = UIRefreshControl(frame: .zero)
    private lazy var dataSource: MessagesTableViewDataSource = {
        return MessagesTableViewDataSource(tableView: self.tableView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.addSubview(refreshIndicator)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.messagesSceneDidSelectMessage(at: indexPath)
    }

    var delegate: MessagesSceneDelegate?

    func showRefreshIndicator() {
        refreshIndicator.beginRefreshing()
    }

    func hideRefreshIndicator() {
        refreshIndicator.endRefreshing()
    }

    func bindMessages(with binder: MessageItemBinder) {
        dataSource.binder = binder
        tableView.reloadData()
    }

    func showMessagesList() {
        tableView.isHidden = false
    }

    func hideMessagesList() {
        tableView.isHidden = true
    }

    func showNoMessagesPlaceholder() {
        noMessagesPlaceholder.isHidden = false
    }

    func hideNoMessagesPlaceholder() {
        noMessagesPlaceholder.isHidden = true
    }

    private class MessagesTableViewDataSource: NSObject, UITableViewDataSource {

        var binder: MessageItemBinder?
        private let cellReuseIdentifier = "MessageCell"

        init(tableView: UITableView) {
            let nib = UINib(nibName: "MessageTableViewCell", bundle: .main)
            tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return binder?.numberOfMessages ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MessageTableViewCell
            binder?.bind(cell, toMessageAt: indexPath)

            return cell
        }

    }

}
