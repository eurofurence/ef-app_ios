//
//  KnowledgeEntryCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeEntryCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }

	var knowledgeEntry: KnowledgeEntry? {
		didSet {
			titleLabel?.text = knowledgeEntry?.Title
		}
	}

}
