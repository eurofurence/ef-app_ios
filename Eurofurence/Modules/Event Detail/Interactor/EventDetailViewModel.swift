//
//  EventDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailViewModel {

    var title: String { get }
    var eventStartEndTime: String { get }
    var location: String { get }
    var trackName: String { get }
    var eventHosts: String { get }

}
