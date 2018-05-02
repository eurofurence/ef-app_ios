//
//  NewsUserWidgetTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class NewsUserWidgetTableViewCell: UITableViewCell, UserWidgetComponent {

    // MARK: Properties

    private let standardUserPromptColor = UIColor(white: 0.5, alpha: 1.0)
    private let highlightedUserPromptColor = UIColor(red: 36.0, green: 87.0, blue: 83.0, alpha: 1.0)

    // MARK: IBOutlets

    @IBOutlet weak var standardUserPromptImageView: UIImageView!
    @IBOutlet weak var highlightedUserPromptImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var detailedPromptLabel: UILabel!

    // MARK: UserWidgetComponent

    func setPrompt(_ prompt: String) {
        promptLabel.text = prompt
    }

    func setDetailedPrompt(_ detailedPrompt: String) {
        detailedPromptLabel.text = detailedPrompt
    }

    func showHighlightedUserPrompt() {
        highlightedUserPromptImageView.isHidden = false
        detailedPromptLabel.textColor = highlightedUserPromptColor
    }

    func hideHighlightedUserPrompt() {
        highlightedUserPromptImageView.isHidden = true
    }

    func showStandardUserPrompt() {
        standardUserPromptImageView.isHidden = false
        detailedPromptLabel.textColor = standardUserPromptColor
    }

    func hideStandardUserPrompt() {
        standardUserPromptImageView.isHidden = true
    }

}
