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

        limitedAvailabilityIconLabel.text = "\u{f071}"
        afterDarkInformationIconLabel.text = "\u{f186}"
    }

    // MARK: DealerLocationAndAvailabilityComponent

    func showMapPNGGraphicData(_ data: Data) {
        dealerMapImageView.image = UIImage(data: data)
    }

    func showDealerLimitedAvailabilityWarning(_ warning: String) {
        limitedAvailabilityWarningLabel.text = warning
        limitedAvailabilityWarningLabel.isHidden = false
    }

    func showLocatedInAfterDarkDealersDenMessage(_ message: String) {
        afterDarkInformationLabel.text = message
        afterDarkInformationLabel.isHidden = false
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
