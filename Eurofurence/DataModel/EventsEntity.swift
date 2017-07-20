//
//  EventsEntity.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol EventsEntity {
	var Name: String { get }
	var Events: [Event] { get }
}

extension EventConferenceDay: EventsEntity {}
extension EventConferenceRoom: EventsEntity {}
extension EventConferenceTrack: EventsEntity {}
