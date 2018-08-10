//
//  ScheduleDayCollectionViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleDayCollectionViewCell: UICollectionViewCell, ScheduleDayComponent {

    @IBOutlet weak var selectedDecorationView: UIView!
    @IBOutlet weak var dayTitleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            updateDecorationViewVisibility()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateDecorationViewVisibility()
    }

    private func updateDecorationViewVisibility() {
        selectedDecorationView.alpha = isSelected ? 1 : 0
    }

    func setDayTitle(_ title: String) {
        dayTitleLabel.text = title
        dayTitleLabel.accessibilityHint = .restrictEventsAccessibilityHint(date: title)
    }

}
