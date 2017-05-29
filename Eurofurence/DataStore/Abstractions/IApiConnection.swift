//
//  ApiConnection.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import EVReflection
import ReactiveSwift

protocol IApiConnection {
	init(apiUrl : String, syncEndpoint : String)

	var syncGet: SignalProducer<Sync, NSError> { get }

	var endpointGet: Action<String, EntityBase, NSError> { get }

	var endpointPost: Action<(String, EVReflectable?), EntityBase, NSError> { get }
}

extension IApiConnection {
	/**
	Maps the given endpoint name to its corresponding EntityBase subclass.
	- parameter name: endpoint to be mapped to an entity type
	- return nil if endpoint name can not be mapped to
	*/
	func getEntityType(name: String) -> EntityBase.Type? {
		switch (name) {
		case "Announcements":
			return Announcement.self
		case "Dealers":
			return Dealer.self
		case "Events":
			return Event.self
		case "EventConferenceDays":
			return EventConferenceDay.self
		case "EventConferenceRooms":
			return EventConferenceRoom.self
		case "EventConferenceTracks":
			return EventConferenceTrack.self
		case "Images":
			return Image.self
		case "KnowledgeEntries":
			return KnowledgeEntry.self
		case "KnowledgeGroups":
			return KnowledgeGroup.self
		case "Maps":
			return Map.self
		default:
			return nil
		}
	}

	/**
	Maps the given entity type to its corresponding endpoint name.
	- parameter name: entity type to be mapped to an endpoint name
	- return nil if entity type can not be mapped
	*/
	func getEndpoint(entityType: EntityBase.Type) -> String? {
		if (entityType is Announcement.Type) {
			return "Announcements"
		} else if (entityType is Dealer.Type) {
			return "Dealers"
		} else if (entityType is Event.Type) {
			return "Events"
		} else if (entityType is EventConferenceDay.Type) {
			return "EventConferenceDays"
		} else if (entityType is EventConferenceRoom.Type) {
			return "EventConferenceRooms"
		} else if (entityType is EventConferenceTrack.Type) {
			return "EventConferenceTracks"
		} else if (entityType is Image.Type) {
			return "Images"
		} else if (entityType is KnowledgeEntry.Type) {
			return "KnowledgeEntries"
		} else if (entityType is KnowledgeGroup.Type) {
			return "KnowledgeGroups"
		} else if (entityType is Map.Type) {
			return "Maps"
		} else {
			return nil
		}
	}
}
