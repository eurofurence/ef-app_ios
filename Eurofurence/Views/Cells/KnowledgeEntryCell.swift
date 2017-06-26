//
//  KnowledgeEntryCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeEntryCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	private var _knowledgeEntry: KnowledgeEntry?
	
	var knowledgeEntry: KnowledgeEntry? {
		get {
			return _knowledgeEntry
		}
		set(knowledgeEntry) {
			_knowledgeEntry = knowledgeEntry
			titleLabel.text = knowledgeEntry?.Title
		}
	}
}
