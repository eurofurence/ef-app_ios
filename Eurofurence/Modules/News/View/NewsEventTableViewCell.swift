//
//  NewsEventTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class NewsEventTableViewCell: UITableViewCell, NewsEventComponent {

    // MARK: IBOutlets

    @IBOutlet weak var eventStartTimeLabel: UILabel!
    @IBOutlet weak var eventEndTimeLabel: UILabel!
    @IBOutlet weak var eventIconImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!

    // MARK: NewsEventComponent

    func setEventStartTime(_ startTime: String) {
        eventStartTimeLabel.text = startTime
    }

    func setEventEndTime(_ endTime: String) {
        eventEndTimeLabel.text = endTime
    }

    func setEventName(_ eventName: String) {
        eventNameLabel.text = eventName
    }

    func setLocation(_ location: String) {
        eventLocationLabel.text = location
    }

    func setIcon(_ icon: UIImage?) {
        eventIconImageView.image = icon
    }

}
