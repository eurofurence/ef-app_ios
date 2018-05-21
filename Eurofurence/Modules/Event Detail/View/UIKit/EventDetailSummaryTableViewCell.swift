//
//  EventDetailSummaryTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventDetailSummaryTableViewCell: UITableViewCell, EventSummaryComponent {

    // MARK: IBOutlets

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventSubtitleLabel: UILabel!
    @IBOutlet weak var eventTimesLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventTrackLabel: UILabel!
    @IBOutlet weak var eventHostsLabel: UILabel!

    // MARK: EventSummaryComponent

    func setEventTitle(_ title: String) {
        eventTitleLabel.text = title
    }

    // TODO: RENAME TO EVENT TIME SOMETHING
    func setEventStartEndTime(_ startEndTime: String) {
        eventTimesLabel.text = startEndTime
    }

    func setEventLocation(_ location: String) {
        eventLocationLabel.text = location
    }

    func setTrackName(_ trackName: String) {
        eventTrackLabel.text = trackName
    }

    func setEventHosts(_ eventHosts: String) {
        eventHostsLabel.text = eventHosts
    }

}
