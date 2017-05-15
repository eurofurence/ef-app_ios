//
//  EventConferenceDay.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class EventConferenceDay: EntityBase {
	var Date = NSDate()
    var Name = ""
	
	var Events : [Event]? = nil
}
