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

    // MARK: Properties

    var pageInfo: TutorialPageInfo? {
        didSet {
            tutorialPageImageView.image = pageInfo?.image
            tutorialPageTitleLabel.text = pageInfo?.title
            tutorialPageDescriptionLabel.text = pageInfo?.description
        }
    }

}
