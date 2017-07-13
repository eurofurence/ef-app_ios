//
//  DataContextProtocol.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol DataContextProtocol {
	var SyncState: MutableProperty<SyncState> { get }

	var Announcements: MutableProperty<[Announcement]> { get }
	var Dealers: MutableProperty<[Dealer]> { get }
	var Events: MutableProperty<[Event]> { get }
	var EventConferenceDays: MutableProperty<[EventConferenceDay]> { get }
	var EventConferenceRooms: MutableProperty<[EventConferenceRoom]> { get }
	var EventConferenceTracks: MutableProperty<[EventConferenceTrack]> { get }
	var EventFavorites: MutableProperty<[EventFavorite]> { get }
	var Images: MutableProperty<[Image]> { get }
	var KnowledgeEntries: MutableProperty<[KnowledgeEntry]> { get }
	var KnowledgeGroups: MutableProperty<[KnowledgeGroup]> { get }
	var Maps: MutableProperty<[Map]> { get }

	/// Action for synchronising with the API (apply parameter: since)
	var applySync: Action<Sync, Progress, DataStoreError> { get }

	/// Signal to be triggered upon changes in any DataContextArea
	var refreshed: Signal<DataContextArea, NoError> { get }

	init(dataStore: DataStoreProtocol, navigationResolver: NavigationResolverProtocol)

	func loadFromStore(_ areas: DataContextArea) -> SignalProducer<Progress, DataStoreError>

	func saveToStore(_ areas: DataContextArea) -> SignalProducer<Progress, DataStoreError>

	func clearAll()
}

extension DataContextProtocol {
	func loadFromStore() -> SignalProducer<Progress, DataStoreError> {
		return loadFromStore(DataContextArea.All)
	}

	func saveToStore() -> SignalProducer<Progress, DataStoreError> {
		return saveToStore(DataContextArea.All)
	}
}

struct DataContextArea: OptionSet, CustomStringConvertible {
	let rawValue: Int

	static let All = DataContextArea(rawValue: 0b111111)
	static let None = DataContextArea(rawValue: 0b000000)
	static let Announcements = DataContextArea(rawValue: 0b000001)
	static let Events = DataContextArea(rawValue: 0b000010)
	static let Knowledge = DataContextArea(rawValue: 0b000100)
	static let Images = DataContextArea(rawValue: 0b001000)
	static let Dealers = DataContextArea(rawValue: 0b010000)
	static let Maps = DataContextArea(rawValue: 0b100000)

	static func get(for entityType: EntityBase.Type) -> DataContextArea {
		switch entityType {
		case is Announcement.Type:
			return self.Announcements
		case is Dealer.Type:
			return self.Dealers
		case is EventConferenceDay.Type:
			return self.Events
		case is EventConferenceRoom.Type:
			return self.Events
		case is EventConferenceTrack.Type:
			return self.Events
		case is Event.Type:
			return self.Events
		case is EventFavorite.Type:
			return self.Events
		case is Image.Type:
			return self.Images
		case is KnowledgeEntry.Type:
			return self.Knowledge
		case is KnowledgeGroup.Type:
			return self.Knowledge
		case is Map.Type:
			return self.Maps
		default:
			return self.None
		}
	}

	var description: String { get {
			var areasStrings: [String] = []

			if self.contains(DataContextArea.Announcements) {
				areasStrings.append("Announcements")
			}
			if self.contains(DataContextArea.Dealers) {
				areasStrings.append("Dealers")
			}
			if self.contains(DataContextArea.Events) {
				areasStrings.append("Events")
			}
			if self.contains(DataContextArea.Images) {
				areasStrings.append("Images")
			}
			if self.contains(DataContextArea.Knowledge) {
				areasStrings.append("Knowledge")
			}
			if self.contains(DataContextArea.Maps) {
				areasStrings.append("Maps")
			}

			return "DataContextArea(\(areasStrings.joined(separator: ", ")))"
		}
	}
}
