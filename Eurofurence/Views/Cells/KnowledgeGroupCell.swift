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
	
	weak private var _knowledgeGroup: KnowledgeGroup?
	
	var knowledgeGroup: KnowledgeGroup? {
		get {
			return _knowledgeGroup
		}
		set(knowledgeGroup) {
			_knowledgeGroup = knowledgeGroup
			iconLabel.text = knowledgeGroup?.FontAwesomeIconCharacterUnicodeAddress
			nameLabel.text = knowledgeGroup?.Name
			descriptionLabel.text = knowledgeGroup?.Description
		}
	}
}
