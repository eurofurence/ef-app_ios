//
//  DealerDetailLocationAndAvailabilityTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealerDetailLocationAndAvailabilityTableViewCell: UITableViewCell, DealerLocationAndAvailabilityComponent {

    // MARK: Properties

    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var dealerMapImageView: UIImageView!
    @IBOutlet weak var limitedAvailabilityWarningContainer: UIStackView!
    @IBOutlet weak var limitedAvailabilityIconLabel: UILabel!
    @IBOutlet weak var limitedAvailabilityWarningLabel: UILabel!
    @IBOutlet weak var afterDarkInformationContainer: UIStackView!
    @IBOutlet weak var afterDarkInformationIconLabel: UILabel!
    @IBOutlet weak var afterDarkInformationLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = false
        accessibilityElements = [
            componentTitleLabel,
            dealerMapImageView,
            limitedAvailabilityWarningContainer,
            afterDarkInformationContainer
        ]

        dealerMapImageView.layer.borderColor = UIColor.lightGray.cgColor
        dealerMapImageView.layer.borderWidth = 1

        limitedAvailabilityIconLabel.textColor = .pantone330U
        limitedAvailabilityIconLabel.text = "\u{f071}"
        afterDarkInformationIconLabel.textColor = .pantone330U
        afterDarkInformationIconLabel.text = "\u{f186}"
    }

    // MARK: DealerLocationAndAvailabilityComponent

    func setComponentTitle(_ title: String) {
        componentTitleLabel.text = title
    }

    func showMapPNGGraphicData(_ data: Data) {
        dealerMapImageView.image = UIImage(data: data)
        dealerMapImageView.isHidden = false
    }

    func showDealerLimitedAvailabilityWarning(_ warning: String) {
        limitedAvailabilityWarningLabel.text = warning
        limitedAvailabilityWarningContainer.isHidden = false
    }

    func showLocatedInAfterDarkDealersDenMessage(_ message: String) {
        afterDarkInformationLabel.text = message
        afterDarkInformationContainer.isHidden = false
    }

    func hideMap() {
        dealerMapImageView.isHidden = true
    }

    func hideLimitedAvailbilityWarning() {
        limitedAvailabilityWarningContainer.isHidden = true
    }

    func hideAfterDarkDenNotice() {
        afterDarkInformationContainer.isHidden = true
    }

}
