//
//  DealerComponentTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealerComponentTableViewCell: UITableViewCell, DealerComponent {

    // MARK: Properties

    @IBOutlet weak var dealerIconImageView: UIImageView!
    @IBOutlet weak var dealerTitleLabel: UILabel!
    @IBOutlet weak var dealerSubtitleLabel: UILabel!
    @IBOutlet weak var notAvailableForEntireConferenceWarningView: UILabel!
    @IBOutlet weak var containsAfterDarkContentWarningView: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        applyFontAwesomeCharacters()
        notAvailableForEntireConferenceWarningView.textColor = .pantone330U
        containsAfterDarkContentWarningView.textColor = .pantone330U
    }

    // MARK: DealerComponent

    func setDealerTitle(_ title: String) {
        dealerTitleLabel.text = title
    }

    func setDealerSubtitle(_ subtitle: String?) {
        dealerSubtitleLabel.text = subtitle
    }

    func setDealerIconPNGData(_ pngData: Data) {
        dealerIconImageView.image = UIImage(data: pngData)
    }

    func showNotPresentOnAllDaysWarning() {
        notAvailableForEntireConferenceWarningView.isHidden = false
    }

    func hideNotPresentOnAllDaysWarning() {
        notAvailableForEntireConferenceWarningView.isHidden = true
    }

    func showAfterDarkContentWarning() {
        containsAfterDarkContentWarningView.isHidden = false
    }

    func hideAfterDarkContentWarning() {
        containsAfterDarkContentWarningView.isHidden = true
    }

    // MARK: Private

    private func applyFontAwesomeCharacters() {
        notAvailableForEntireConferenceWarningView.text = "\u{f071}"
        containsAfterDarkContentWarningView.text = "\u{f186}"
    }

}
