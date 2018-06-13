//
//  NewsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class NewsViewController: UIViewController, NewsScene {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties

    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventTableViewCell.self)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        delegate?.newsSceneDidLoad()
    }

    // MARK: NewsScene

    var delegate: NewsSceneDelegate?

    func showNewsTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder) {
        tableController = TableController(tableView: tableView, numberOfItemsPerComponent: numberOfItemsPerComponent, binder: binder)
        tableController?.onDidSelectRowAtIndexPath = tableViewDidSelectRow
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.reloadData()
    }

    // MARK: Private

    func tableViewDidSelectRow(at indexPath: IndexPath) {
        delegate?.newsSceneDidSelectComponent(at: indexPath)
    }

    // MARK: Nested Types

    private class Header: UITableViewHeaderFooterView, NewsComponentHeaderScene {

        static let identifier = "Header"

        func setComponentTitle(_ title: String?) {
            textLabel?.text = title
        }

    }

    private class TableController: NSObject, NewsComponentFactory, UITableViewDataSource, UITableViewDelegate {

        private let tableView: UITableView
        private let numberOfItemsPerComponent: [Int]
        private let binder: NewsComponentsBinder
        var onDidSelectRowAtIndexPath: ((IndexPath) -> Void)?

        init(tableView: UITableView, numberOfItemsPerComponent: [Int], binder: NewsComponentsBinder) {
            self.tableView = tableView
            self.numberOfItemsPerComponent = numberOfItemsPerComponent
            self.binder = binder
        }

        // MARK: NewsComponentFactory

        typealias Component = UITableViewCell

        func makeConventionCountdownComponent(configuringUsing block: (ConventionCountdownComponent) -> Void) -> UITableViewCell {
            return manufacture(NewsConventionCountdownTableViewCell.self, configuration: block)
        }

        func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> Component {
            return manufacture(NewsUserWidgetTableViewCell.self, configuration: block)
        }

        func makeAnnouncementComponent(configuringUsing block: (NewsAnnouncementComponent) -> Void) -> UITableViewCell {
            return manufacture(NewsAnnouncementTableViewCell.self, configuration: block)
        }

        func makeEventComponent(configuringUsing block: (NewsEventComponent) -> Void) -> UITableViewCell {
            return manufacture(EventTableViewCell.self, configuration: block)
        }

        private func manufacture<T>(_ cellType: T.Type, configuration: (T) -> Void) -> T where T: UITableViewCell {
            let cell = tableView.dequeue(cellType)
            configuration(cell)
            return cell
        }

        // MARK: UITableViewDataSource

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfItemsPerComponent.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfItemsPerComponent[section]
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

        // MARK: UITableViewDelegate

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
            binder.bindTitleForSection(at: section, scene: header)
            return header
        }

        // MARK: Functions

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath?(indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }

    }

}
