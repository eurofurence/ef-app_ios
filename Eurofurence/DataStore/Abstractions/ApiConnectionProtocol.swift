//
//  ApiConnectionProtocol.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import AlamofireImage
import EVReflection
import Foundation
import ReactiveSwift

protocol ApiConnectionProtocol {
	
	typealias AFImage = AlamofireImage.Image
	typealias Parameters = [String: Any]

	var apiUrl: URL { get }

	// MARK: Initializers

	init(_ apiUrl: URL)

	init?(_ apiUrlString: String)

	// MARK: General HTTP verbs

	func doGet<EntityType:EVNetworkingObject>(_ endpoint: String, parameters: Parameters?) -> SignalProducer<EntityType, ApiConnectionError>

	func doPost<EntityType:EVNetworkingObject>(_ endpoint: String, payload: EVReflectable?, parameters: Parameters?) -> SignalProducer<EntityType, ApiConnectionError>

	func doPut<EntityType:EVNetworkingObject>(_ endpoint: String, payload: EVReflectable?, parameters: Parameters?) -> SignalProducer<EntityType, ApiConnectionError>

	func doDelete<EntityType:EVNetworkingObject>(_ endpoint: String, parameters: Parameters?) -> SignalProducer<EntityType, ApiConnectionError>
	
	// MARK: Specialised functions
	
	func downloadImage(image: Image) -> SignalProducer<AFImage, ApiConnectionError>
}

extension ApiConnectionProtocol {
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
}


enum ApiConnectionError: CustomNSError {
	case InvalidParameter(functionName: String, description: String?)
	case NotFound(entityType: String, description: String?)
	case NotImplemented(functionName: String)
	case UnknownError(functionName: String, description: String?)
	case HttpError(endpoint: String, verb: String, description: String?)

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
		case .HttpError:
			return 1
		}
	}

	var errorUserInfo: [String: AnyObject] {
		switch self {
		case .InvalidParameter(let functionName, let description):
			return ["message": "Invalid parameter for function \(functionName)" as NSString,
			        "description": (description ?? "") as NSString]
		case .NotFound(let entityType, let description):
			return ["message": "Entity of type \(entityType) could not be found" as NSString,
			        "description": (description ?? "") as NSString]
		case .NotImplemented(let functionName):
			return ["message": "Function \(functionName) is not (yet) implemented" as NSString,
			        "description": "" as NSString]
		case .UnknownError(let functionName, let description):
			return ["message": "An unknown error occurred in function \(functionName)" as NSString,
			        "description": (description ?? "") as NSString]
		case .HttpError(let endpoint, let verb, let description):
			return ["message": "An error occurred while processing a HTTP \(verb) request on endpoint \(endpoint)" as NSString,
			        "description": (description ?? "") as NSString]
		}
	}
}
