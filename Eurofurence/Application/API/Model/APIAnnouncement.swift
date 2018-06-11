//
//  APIAnnouncement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIAnnouncement: Equatable {

    var identifier: String
    var title: String
    var content: String
    var lastChangedDateTime: Date

}
