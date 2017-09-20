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

    }

    func showMessages(_ viewModel: MessagesViewModel) {
        dataSource.viewModel = viewModel
        tableView.reloadData()
    }

    func showMessagesList() {

    }

    func hideMessagesList() {

    }

    func showNoMessagesPlaceholder() {

    }

    func hideNoMessagesPlaceholder() {

    }

    private class MessagesTableViewDataSource: NSObject, UITableViewDataSource {

        var viewModel = MessagesViewModel(childViewModels: [])
        private let cellReuseIdentifier = "MessageCell"

        init(tableView: UITableView) {
            let nib = UINib(nibName: "MessageTableViewCell", bundle: .main)
            tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfMessages
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let messageViewModel = viewModel.messageViewModel(at: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MessageTableViewCell
            bind(cell, to: messageViewModel)

            return cell
        }

        private func bind(_ cell: MessageTableViewCell, to messageViewModel: MessageViewModel) {
            cell.messageAuthorLabel.text = messageViewModel.author
            cell.messageReceivedDateLabel.text = messageViewModel.formattedReceivedDate
            cell.messageSubjectLabel.text = messageViewModel.subject
            cell.messageSynopsisLabel.text = messageViewModel.message
            cell.unreadMessageIndicator.isHidden = messageViewModel.isRead
        }

    }

}
