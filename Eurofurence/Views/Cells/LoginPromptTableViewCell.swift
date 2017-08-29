//
//  LoginPromptTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class LoginPromptTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var welcomePromptLabel: UILabel!
    @IBOutlet weak var welcomePromptDescription: UILabel!

    // MARK: Functions

    func showPrompt(_ prompt: String) {
        welcomePromptLabel.text = prompt
    }

    func showDescription(_ description: String) {
        welcomePromptDescription.text = description
    }

}
