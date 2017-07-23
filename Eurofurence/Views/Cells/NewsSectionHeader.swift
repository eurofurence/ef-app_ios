//
//  NewsSectionHeader.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class NewsSectionHeader: UITableViewHeaderFooterView {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var showAllButton: UIButton!
	private var _toggleShowAllAction: ((_ cell: NewsSectionHeader) -> Void)?

	var isShowAll: Bool {
		get {
			return (!showAllButton.isHidden && showAllButton.isSelected) ||
				showAllButton.isHidden
		}
		set(isShowAll) {
			showAllButton.isSelected = isShowAll
		}
	}

	var sectionTitle: String? {
		get {
			return titleLabel.text
		}
		set(title) {
			titleLabel.text = title
		}
	}

	var toggleShowAllAction: ((_ cell: NewsSectionHeader) -> Void)? {
		get {
			return _toggleShowAllAction
		}
		set(action) {
			if action == nil {
				showAllButton.isHidden = true
			} else {
				showAllButton.isHidden = false
			}
			_toggleShowAllAction = action
		}
	}

	override func awakeFromNib() {
		toggleShowAllAction = nil
	}

	@IBAction func toggleShowAll(_ sender: UIButton) {
		guard let toggleShowAllAction = toggleShowAllAction else { return }

		sender.isSelected = !sender.isSelected
		toggleShowAllAction(self)
	}
}
