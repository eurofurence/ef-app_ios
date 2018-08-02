//
//  EventTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, ScheduleEventComponent {

    // MARK: IBOutlets

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var favouritedImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var superSponsorEventIndicator: UIView!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        favouritedImageView.tintColor = .red
    }

    // MARK: ScheduleEventComponent

    func setEventStartTime(_ startTime: String) {
        startTimeLabel.text = startTime
    }

    func setEventEndTime(_ endTime: String) {
        endTimeLabel.text = endTime
    }

    func setEventName(_ eventName: String) {
        eventNameLabel.text = eventName
    }

    func setLocation(_ location: String) {
        locationLabel.text = location
    }

    func showFavouriteEventIndicator() {
        favouritedImageView.isHidden = false
    }

    func hideFavouriteEventIndicator() {
        favouritedImageView.isHidden = true
    }

    func showSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = false
    }

    func hideSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = true
    }

}
