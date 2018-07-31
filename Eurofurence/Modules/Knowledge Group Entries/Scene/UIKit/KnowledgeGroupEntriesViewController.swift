//
//  KnowledgeGroupEntriesViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeGroupEntriesViewController: UITableViewController, KnowledgeGroupEntriesScene {

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        knowledgeGroupEntriesSceneDelegate?.knowledgeGroupEntriesSceneDidLoad()
    }

    private var numberOfRows = 0
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    private var binder: KnowledgeGroupEntriesBinder?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(KnowledgeListEntryTableViewCell.self)
        binder?.bind(cell, at: indexPath.row)
        return cell
    }

    // MARK: KnowledgeGroupEntriesScene

    private var knowledgeGroupEntriesSceneDelegate: KnowledgeGroupEntriesSceneDelegate?
    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate) {
        self.knowledgeGroupEntriesSceneDelegate = delegate
    }

    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder) {
        numberOfRows = numberOfEntries
        self.binder = binder

        tableView?.reloadData()
    }

}
