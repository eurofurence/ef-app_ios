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
	typealias Parameters = [String: Any]

	var apiUrl : URL { get }
	var syncEndpoint : String { get }

	// MARK: Initializers

	init(_ apiUrl : URL, _ syncEndpoint : String)
	init?(_ apiUrlString : String, _ syncEndpoint : String)

	// MARK: Custom API operations

	func doGetSync(parameters : Parameters?) -> SignalProducer<Sync, ApiConnectionError>
	func doGetAnnouncements(by id : String) -> SignalProducer<Announcement, ApiConnectionError>
	func doGetImageContent(by id : String) -> SignalProducer<UIImage, ApiConnectionError>

	// MARK: General HTTP verbs

	func doGet(_ endpoint : String, parameters : Parameters?) -> SignalProducer<EVObject, ApiConnectionError>
	func doPost(_ endpoint : String, payload : EVReflectable?, parameters : Parameters?) -> SignalProducer<EVObject, ApiConnectionError>
	func doPut(_ endpoint : String, payload : EVReflectable?, parameters : Parameters?) -> SignalProducer<EVObject, ApiConnectionError>
	func doDelete(_ endpoint : String, parameters : Parameters?) -> SignalProducer<EVObject, ApiConnectionError>
}

extension IApiConnection {
	/**
	Maps the given endpoint name to its corresponding EntityBase subclass.
	- parameter name: endpoint to be mapped to an entity type
	- return nil if endpoint name can not be mapped to
	*/
	func getEntityType(name: String) -> EVObject.Type? {
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
		case "Sync":
			return Sync.self
		default:
			return nil
		}
	}

	/**
	Maps the given entity type to its corresponding endpoint name.
	- parameter name: entity type to be mapped to an endpoint name
	- return nil if entity type can not be mapped
	*/
	func getEndpoint(entityType: EVObject.Type) -> String? {
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
		} else if (entityType is Sync.Type) {
			return "Sync"
		} else {
			return nil
		}
	}

	func getEndpointName(url : URL) -> String {
		return getEndpointName(urlString: url.absoluteString)
	}

	func getEndpointName(urlString : String) -> String {
		return ""
	}
}


enum ApiConnectionError: CustomNSError {
	case InvalidParameter(functionName: String, description: String?)
	case NotFound(entityType: String, description: String?)
	case NotImplemented(functionName: String)
	case UnknownError(functionName: String, description: String?)

	static var errorDomain: String {
		return "ApiConnectionError"
	}

	var errorCode: Int {
		switch self {
		case .InvalidParameter:
			return 400
		case .NotFound:
			return 404
		case .NotImplemented:
		    return 501
		case .UnknownError:
			return Int.max
		}
	}

	var errorUserInfo: [String : AnyObject] {
		switch self {
		case .InvalidParameter(let functionName, let description):
			return ["message" : "Invalid parameter for function \(functionName)" as NSString,
					"description" : (description ?? "") as NSString]
		case .NotFound(let entityType, let description):
			return ["message" : "Entity of type \(entityType) could not be found" as NSString,
			        "description" : (description ?? "") as NSString]
		case .NotImplemented(let functionName):
			return ["message" : "Function \(functionName) is not (yet) implemented" as NSString,
			        "description" : "" as NSString]
		case .UnknownError(let functionName, let description):
			return ["message" : "An unknown error occurred in function \(functionName)" as NSString,
			        "description" : (description ?? "") as NSString]
		}
	}
}