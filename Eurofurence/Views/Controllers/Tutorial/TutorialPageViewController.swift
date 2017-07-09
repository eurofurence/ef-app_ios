//
//  TutorialPageViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIViewController, TutorialPageScene {

    // MARK: IBOutlets

    @IBOutlet weak var tutorialPageImageView: UIImageView!
    @IBOutlet weak var tutorialPageTitleLabel: UILabel!
    @IBOutlet weak var tutorialPageDescriptionLabel: UILabel!
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: RoundedCornerButton!

    // MARK: IBActions

    @IBAction func performPrimaryAction(_ sender: Any) {
        pageInfo?.runPrimaryAction()
    }

    @IBAction func performSecondaryAction(_ sender: Any) {
        pageInfo?.runSecondaryAction()
    }

    // MARK: TutorialPageScene

    func showPageTitle(_ title: String?) {

    }

    func showPageDescription(_ description: String?) {

    }

    func showPageImage(_ image: UIImage?) {

    }

    func showPrimaryActionButton() {

    }

    func showPrimaryActionDescription(_ primaryActionDescription: String) {

    }

    func showSecondaryActionButton() {

    }

    func showSecondaryActionDescription(_ secondaryActionDescription: String) {

    }

    // MARK: Properties

    var pageInfo: TutorialPageInfo? {
        didSet {
            updatePage()
        }
    }

    // MARK: Private

    private func updatePage() {
        updateStaticInformationViews()
        updatePrimaryButton()
        updateSecondaryButton()
    }

    private func updateStaticInformationViews() {
        tutorialPageImageView.image = pageInfo?.image
        tutorialPageTitleLabel.text = pageInfo?.title
        tutorialPageDescriptionLabel.text = pageInfo?.description
    }

    private func updatePrimaryButton() {
        update(button: primaryActionButton, title: pageInfo?.primaryActionDescription)
    }

    private func updateSecondaryButton() {
        update(button: secondaryActionButton, title: pageInfo?.secondaryActionDescription)
    }

    private func update(button: UIButton, title: String?) {
        if let title = title {
            button.isHidden = false
            button.setTitle(title, for: .normal)
        } else {
            button.isHidden = true
        }
    }

}
