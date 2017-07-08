//
//  TutorialPageViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var tutorialPageImageView: UIImageView!
    @IBOutlet weak var tutorialPageTitleLabel: UILabel!
    @IBOutlet weak var tutorialPageDescriptionLabel: UILabel!
    @IBOutlet weak var primaryActionButton: UIButton!

    // MARK: IBActions

    @IBAction func performPrimaryAction(_ sender: Any) {
        pageInfo?.runPrimaryAction()
    }

    // MARK: Properties

    var pageInfo: TutorialPageInfo? {
        didSet {
            tutorialPageImageView.image = pageInfo?.image
            tutorialPageTitleLabel.text = pageInfo?.title
            tutorialPageDescriptionLabel.text = pageInfo?.description

            if let primaryActionDescription = pageInfo?.primaryActionDescription {
                primaryActionButton.isHidden = false
                primaryActionButton.titleLabel?.text = primaryActionDescription
            } else {
                primaryActionButton.isHidden = true
            }
        }
    }

}
