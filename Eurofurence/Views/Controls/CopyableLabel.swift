//
//  CopyableLabel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class CopyableLabel: UILabel {
	override var canBecomeFirstResponder: Bool {
		return true
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	override func copy(_ sender: Any?) {
		let board = UIPasteboard.general
		board.string = text

		let menu = UIMenuController.shared
		menu.setMenuVisible(false, animated: true)
	}

	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if action == #selector(copy(_:)) {
			return true
		}
		return false
	}

	private func setup() {
		isUserInteractionEnabled = true
		addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
	}

	@objc private func showMenu(sender: AnyObject?) {
		becomeFirstResponder()
		let menu = UIMenuController.shared
		if !menu.isMenuVisible {
			menu.setTargetRect(bounds, in: self)
			menu.setMenuVisible(true, animated: true)
		}
	}
}
