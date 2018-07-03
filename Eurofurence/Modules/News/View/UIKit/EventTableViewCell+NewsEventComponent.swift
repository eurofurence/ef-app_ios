//
//  EventTableViewCell+NewsEventComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

extension EventTableViewCell: NewsEventComponent {

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

    func setIcon(_ icon: UIImage?) {
        iconImageView.image = icon
    }

    func showFavouriteEventIndicator() {

    }

    func hideFavouriteEventIndicator() {

    }

}
