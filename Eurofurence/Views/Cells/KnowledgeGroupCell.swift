//
//  KnowledgeGroupCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeGroupCell: UITableViewCell {

	@IBOutlet weak var iconLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	var knowledgeGroup: KnowledgeGroup? {
		didSet {
			iconLabel.text = knowledgeGroup?.FontAwesomeIconCharacterUnicodeAddress
			nameLabel.text = knowledgeGroup?.Name
			descriptionLabel.text = knowledgeGroup?.Description
		}
	}
}
