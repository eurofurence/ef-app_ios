//
//  ApiConnection.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 06.05.17.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation

protocol IApiConnection {
	
	var apiUrl : String {get}
	var syncEndpoint : String {get}
	
	typealias ApiResponse = (NSDictionary?, NSError?) -> Void
	typealias ProgressHandler = (Progress) -> Void
	
	init(apiUrl : String, syncEndpoint : String)
	
	func doSyncGet(apiResponse : ApiResponse,
	                    progressHandler : ProgressHandler?) -> Void
	
	func doEndpointGet(endpoint : String, apiResponse : ApiResponse,
	                 progressHandler : ProgressHandler?) -> Void
	
	func doEndpointPost(endpoint : String, apiResponse : ApiResponse,
	                  progressHandler : ProgressHandler?) -> Void
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
}
