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

    // MARK: DealerDetailSummaryComponent

    func showArtistArtworkImageWithPNGData(_ data: Data) {
        artistImageView.image = UIImage(data: data)
    }

    func setDealerTitle(_ title: String) {
        dealerTitleLabel.text = title
    }

    func setDealerSubtitle(_ subtitle: String) {
        dealerSubtitleLabel.text = subtitle
    }

    func setDealerCategories(_ categories: String) {
        dealerCategoriesLabel.text = categories
    }

    func setDealerShortDescription(_ shortDescription: String) {
        dealerShortDescriptionLabel.text = shortDescription
    }

}
