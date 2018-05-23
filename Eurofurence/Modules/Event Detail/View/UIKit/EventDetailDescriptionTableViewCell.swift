//
//  EventDetailDescriptionTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventDetailDescriptionTableViewCell: UITableViewCell, EventDescriptionComponent {

    // MARK: IBOutlets

    @IBOutlet weak var eventDescriptionTextView: UITextView!

    // MARK: EventDescriptionComponent

    func setEventDescription(_ eventDescription: String) {
        eventDescriptionTextView.text = eventDescription
    }

}
