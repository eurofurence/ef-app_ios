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

    private lazy var favouriteEventBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Favorite"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(favouriteButtonTapped))
    private lazy var unfavouriteEventBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Unfavourite"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(unfavouriteButtonTapped))

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        favouriteEventBarButtonItem.accessibilityLabel = .favourite
        unfavouriteEventBarButtonItem.accessibilityLabel = .unfavourite
        delegate?.eventDetailSceneDidLoad()
    }

    // MARK: EventDetailScene

    private var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(numberOfComponents: Int, using binder: EventDetailBinder) {
        tableController = TableController(tableView: tableView,
                                          numberOfComponents: numberOfComponents,
                                          binder: binder)
    }

    func showUnfavouriteEventButton() {
        navigationItem.setRightBarButton(unfavouriteEventBarButtonItem, animated: true)
    }

    func showFavouriteEventButton() {
        navigationItem.setRightBarButton(favouriteEventBarButtonItem, animated: true)
    }

    // MARK: Private

    @objc private func favouriteButtonTapped() {
        delegate?.eventDetailSceneDidTapFavouriteEventButton()
    }

    @objc private func unfavouriteButtonTapped() {
        delegate?.eventDetailSceneDidTapUnfavouriteEventButton()
    }

    private class TableController: NSObject, UITableViewDataSource, EventDetailComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: EventDetailBinder

        init(tableView: UITableView, numberOfComponents: Int, binder: EventDetailBinder) {
            self.tableView = tableView
            self.numberOfComponents = numberOfComponents
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
            let cell = tableView.dequeue(EventDetailDescriptionTableViewCell.self)
            block(cell)
            return cell
        }

        func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailBannerTableViewCell.self)
            block(cell)
            return cell
        }

        func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component {
            let cell = tableView.dequeue(EventInformationBannerTableViewCell.self)
            block(cell)
            cell.iconLabel.text = ""

            return cell
        }

        // MARK: UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfComponents
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

    }

}
