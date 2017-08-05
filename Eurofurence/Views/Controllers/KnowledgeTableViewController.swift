//
//  KnowledgeTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeTableViewController: UITableViewController {

	let dataContext: DataContextProtocol = try! ContextResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))
        tableView.estimatedRowHeight = 32
        tableView.estimatedSectionHeaderHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataContext.KnowledgeGroups.value.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataContext.KnowledgeGroups.value[section].KnowledgeEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledgeEntryCell", for: indexPath) as? KnowledgeEntryCell else {
			return UITableViewCell(frame: .zero)
		}

		cell.knowledgeEntry = dataContext.KnowledgeGroups.value[indexPath.section].KnowledgeEntries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledgeGroupCell") as? KnowledgeGroupCell else {
			return nil
		}

		cell.knowledgeGroup = dataContext.KnowledgeGroups.value[section]

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "KnowledgeEntryDetailSegue" {
			if let destinationVC = segue.destination as? KnowledgeEntryViewController, let cell = sender as? KnowledgeEntryCell, let knowledgeEntry = cell.knowledgeEntry {
				destinationVC.knowledgeEntry = knowledgeEntry
			}
        }
    }

}
