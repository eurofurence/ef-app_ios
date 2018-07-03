//
//  AnnouncementsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController, AnnouncementsScene {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(AnnouncementTableViewCell.self)
        delegate?.announcementsSceneDidLoad()
    }

    // MARK: AnnouncementsScene

    private var delegate: AnnouncementsSceneDelegate?
    func setDelegate(_ delegate: AnnouncementsSceneDelegate) {
        self.delegate = delegate
    }

    func setAnnouncementsTitle(_ title: String) {
        navigationItem.title = title
    }

    func bind(numberOfAnnouncements: Int, using binder: AnnouncementsBinder) {
        tableController = TableController(numberOfAnnouncements: numberOfAnnouncements,
                                          binder: binder,
                                          onDidSelectRowAtIndexPath: didSelectRowAtIndexPath)
    }

    // MARK: Private

    private func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        delegate?.announcementsSceneDidSelectAnnouncement(at: indexPath.item)
    }

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let numberOfAnnouncements: Int
        private let binder: AnnouncementsBinder
        private let onDidSelectRowAtIndexPath: (IndexPath) -> Void

        init(numberOfAnnouncements: Int,
             binder: AnnouncementsBinder,
             onDidSelectRowAtIndexPath: @escaping (IndexPath) -> Void) {
            self.numberOfAnnouncements = numberOfAnnouncements
            self.binder = binder
            self.onDidSelectRowAtIndexPath = onDidSelectRowAtIndexPath
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfAnnouncements
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(AnnouncementTableViewCell.self)
            binder.bind(cell, at: indexPath.row)
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath(indexPath)
        }

    }

}
