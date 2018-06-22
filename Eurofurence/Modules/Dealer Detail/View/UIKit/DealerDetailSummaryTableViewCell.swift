//
//  DealerDetailSummaryTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealerDetailSummaryTableViewCell: UITableViewCell, DealerDetailSummaryComponent {

    // MARK: Properties

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var dealerTitleLabel: UILabel!
    @IBOutlet weak var dealerSubtitleLabel: UILabel!
    @IBOutlet weak var dealerCategoriesLabel: UILabel!
    @IBOutlet weak var dealerShortDescriptionLabel: UILabel!
    @IBOutlet weak var dealerWebsiteButton: UIButton!
    @IBOutlet weak var dealerWebsiteContainer: UIView!
    @IBOutlet weak var dealerTwitterHandleButton: UIButton!
    @IBOutlet weak var dealerTwitterHandleContainer: UIView!
    @IBOutlet weak var dealerTelegramHandleButton: UIButton!
    @IBOutlet weak var dealerTelegramContainer: UIView!

    // MARK: Actions

    @IBAction func websiteButtonTapped(_ sender: Any) {
        websiteSelected?()
    }

    @IBAction func twitterButtonTapped(_ sender: Any) {
        twitterSelected?()
    }

    @IBAction func telegramButtonTapped(_ sender: Any) {
        telegramSelected?()
    }

    // MARK: DealerDetailSummaryComponent

    func showArtistArtworkImageWithPNGData(_ data: Data) {
        artistImageView.image = UIImage(data: data)
        artistImageView.isHidden = false
    }

    func hideArtistArtwork() {
        artistImageView.isHidden = true
    }

    func setDealerTitle(_ title: String) {
        dealerTitleLabel.text = title
        dealerTitleLabel.isHidden = false
    }

    func showDealerSubtitle(_ subtitle: String) {
        dealerSubtitleLabel.text = subtitle
        dealerSubtitleLabel.isHidden = false
    }

    func hideDealerSubtitle() {
        dealerSubtitleLabel.isHidden = true
    }

    func setDealerCategories(_ categories: String) {
        dealerCategoriesLabel.text = categories
    }

    func showDealerShortDescription(_ shortDescription: String) {
        dealerShortDescriptionLabel.text = shortDescription
        dealerShortDescriptionLabel.isHidden = false
    }

    func hideDealerShortDescription() {
        dealerShortDescriptionLabel.isHidden = true
    }

    func showDealerWebsite(_ website: String) {
        dealerWebsiteButton.titleLabel?.text = website
        dealerWebsiteContainer.isHidden = false
    }

    func hideDealerWebsite() {
        dealerWebsiteContainer.isHidden = true
    }

    func showDealerTwitterHandle(_ twitterHandle: String) {
        dealerTwitterHandleButton.titleLabel?.text = twitterHandle
        dealerTwitterHandleContainer.isHidden = false
    }

    func hideTwitterHandle() {
        dealerTwitterHandleContainer.isHidden = true
    }

    func showDealerTelegramHandle(_ telegramHandle: String) {
        dealerTelegramHandleButton.titleLabel?.text = telegramHandle
        dealerTelegramContainer.isHidden = false
    }

    func hideTelegramHandle() {
        dealerTelegramContainer.isHidden = true
    }

    private var websiteSelected: (() -> Void)?
    func onWebsiteSelected(perform block: @escaping () -> Void) {
        websiteSelected = block
    }

    private var twitterSelected: (() -> Void)?
    func onTwitterSelected(perform block: @escaping () -> Void) {
        twitterSelected = block
    }

    private var telegramSelected: (() -> Void)?
    func onTelegramSelected(perform block: @escaping () -> Void) {
        telegramSelected = block
    }

}
