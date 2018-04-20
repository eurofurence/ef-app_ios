//
//  NewsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class NewsViewController: UIViewController, NewsScene, NewsComponentFactory {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var bannerContainer: UIStackView!
    @IBOutlet weak var loginNavigationAction: UIView!
    @IBOutlet weak var loginNavigationTrigger: UIButton!
    @IBOutlet weak var messagesNavigationAction: UIView!
    @IBOutlet weak var messagesNavigationTrigger: UIButton!
    @IBOutlet weak var welcomePromptLabel: UILabel!
    @IBOutlet weak var welcomeDescriptionLabel: UILabel!
    @IBOutlet weak var loginPromptLabel: UILabel!
    @IBOutlet weak var loginPromptDescriptionLabel: UILabel!

    // MARK: IBActions

    @IBAction func loginNavigationActionTapped(_ sender: Any) {
        delegate?.newsSceneDidTapLoginAction(self)
    }

    @IBAction func messagesNavigationActionTapped(_ sender: Any) {
        delegate?.newsSceneDidTapShowMessagesAction(self)
    }

    // MARK: Properties

    private var tableViewDataSource: UITableViewDataSource?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = bannerContainer
        loginNavigationAction.isHidden = true
        messagesNavigationAction.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        delegate?.newsSceneWillAppear()
    }

    // MARK: NewsScene

    var delegate: NewsSceneDelegate?

    func showNewsTitle(_ title: String) {
        super.title = title
    }

    func showMessagesNavigationAction() {
        messagesNavigationAction.isHidden = false
    }

    func hideMessagesNavigationAction() {
        messagesNavigationAction.isHidden = true
    }

    func showLoginNavigationAction() {
        loginNavigationAction.isHidden = false
    }

    func hideLoginNavigationAction() {
        loginNavigationAction.isHidden = true
    }

    func showWelcomePrompt(_ prompt: String) {
        welcomePromptLabel.text = prompt
    }

    func showWelcomeDescription(_ description: String) {
        welcomeDescriptionLabel.text = description
    }

    func showLoginPrompt(_ prompt: String) {
        loginPromptLabel.text = prompt
    }

    func showLoginDescription(_ description: String) {
        loginPromptDescriptionLabel.text = description
    }

    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder) {
        tableViewDataSource = DataSource(numberOfItemsPerComponent: numberOfItemsPerComponent, binder: binder, componentFactory: self)
        tableView.dataSource = tableViewDataSource
    }

    // MARK: NewsComponentFactory

    typealias Component = UITableViewCell

    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> Component {
        fatalError("Not yet implemented")
    }

    func makeAnnouncementComponent(configuringUsing block: (NewsAnnouncementComponent) -> Void) -> UITableViewCell {
        let cell = tableView.dequeue(NewsAnnouncementTableViewCell.self)
        block(cell)
        return cell
    }

    func makeEventComponent(configuringUsing block: (NewsEventComponent) -> Void) -> UITableViewCell {
        let cell = tableView.dequeue(NewsEventTableViewCell.self)
        block(cell)
        return cell
    }

    // MARK: Nested Types

    private class DataSource<T>: NSObject, UITableViewDataSource where T: NewsComponentFactory, T.Component == UITableViewCell {

        private let numberOfItemsPerComponent: [Int]
        private let binder: NewsComponentsBinder
        private let componentFactory: T

        init(numberOfItemsPerComponent: [Int], binder: NewsComponentsBinder, componentFactory: T) {
            self.numberOfItemsPerComponent = numberOfItemsPerComponent
            self.binder = binder
            self.componentFactory = componentFactory
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return numberOfItemsPerComponent.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfItemsPerComponent[section]
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: componentFactory)
        }

    }

}
