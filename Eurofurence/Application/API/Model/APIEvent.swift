//
//  APIEvent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIEvent: Equatable {

    var identifier: String
    var roomIdentifier: String
    var trackIdentifier: String
    var dayIdentifier: String
    var startDateTime: Date
    var endDateTime: Date
    var title: String
    var abstract: String
    var panelHosts: String
    var eventDescription: String
    var posterImageId: String?
    var bannerImageId: String?

}
