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

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func showMessages(_ viewModel: MessagesViewModel) {

    }

}
