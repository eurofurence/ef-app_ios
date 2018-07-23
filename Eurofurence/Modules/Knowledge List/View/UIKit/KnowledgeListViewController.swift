//
//  KnowledgeListViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeListViewController: UIViewController, KnowledgeListScene {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: KnowledgeListScene

    private var delegate: KnowledgeListSceneDelegate?
    func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
        self.delegate = delegate
    }

    func setKnowledgeListTitle(_ title: String) {
        navigationItem.title = title
    }

    func setKnowledgeListShortTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    private lazy var tableViewRenderer = TableViewDataSource()
    func prepareToDisplayKnowledgeGroups(entriesPerGroup: [Int], binder: KnowledgeListBinder) {
        tableViewRenderer.entryCounts = entriesPerGroup
        tableViewRenderer.binder = binder

        tableView.reloadData()
    }

    func deselectKnowledgeEntry(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRenderer.onDidSelectRowAtIndexPath = didSelectRow
        tableView.dataSource = tableViewRenderer
        tableView.delegate = tableViewRenderer
        tableView.estimatedSectionHeaderHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        delegate?.knowledgeListSceneDidLoad()
    }

    // MARK: Private

    private func didSelectRow(at indexPath: IndexPath) {
        delegate?.knowledgeListSceneDidSelectKnowledgeEntry(inGroup: indexPath.section, at: indexPath.row)
    }

    private class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

        var entryCounts = [Int]()
        var binder: KnowledgeListBinder?
        var onDidSelectRowAtIndexPath: ((IndexPath) -> Void)?

        func numberOfSections(in tableView: UITableView) -> Int {
            return entryCounts.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return entryCounts[section]
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(KnowledgeListEntryTableViewCell.self, for: indexPath)
            binder?.bind(cell, toEntryInGroup: indexPath.section, at: indexPath.row)

            return cell
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeue(KnowledgeListSectionHeaderTableViewCell.self)
            binder?.bind(header, toGroupAt: section)

            return header
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            onDidSelectRowAtIndexPath?(indexPath)
        }

    }

}
