//
//  ReactiveDataContext.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-22.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ReactiveDataContext: IDataContext {
	private let (lifetime, token) = Lifetime.make()
	fileprivate let dataStore: IDataStore
	fileprivate let navigationResolver: INavigationResolver

	let Announcements = MutableProperty<[Announcement]>([])
	let Dealers = MutableProperty<[Dealer]>([])
	let EventConferenceDays = MutableProperty<[EventConferenceDay]>([])
	let EventConferenceRooms = MutableProperty<[EventConferenceRoom]>([])
	let EventConferenceTracks = MutableProperty<[EventConferenceTrack]>([])
	let Events = MutableProperty<[Event]>([])
	let Images = MutableProperty<[Image]>([])
	let KnowledgeEntries = MutableProperty<[KnowledgeEntry]>([])
	let KnowledgeGroups = MutableProperty<[KnowledgeGroup]>([])
	let Maps = MutableProperty<[Map]>([])

	let refreshed: Signal<DataContextArea, NoError>
	fileprivate let refreshedInput: Observer<DataContextArea, NoError>

	required init(dataStore: IDataStore, navigationResolver: INavigationResolver) {
		(refreshed, refreshedInput) = Signal<DataContextArea, NoError>.pipe()

		self.dataStore = dataStore
		self.navigationResolver = navigationResolver
	}

	func loadFromStore(_ areas: DataContextArea = DataContextArea.All) -> SignalProducer<Progress, DataStoreError> {
		return SignalProducer { observer, disposable in

			var producers: [SignalProducer<DataStoreResult, DataStoreError>] = []

			if areas.contains(.Announcements) {
				producers.append(self.dataStore.load(Announcement.self))
			}
			if areas.contains(.Dealers) {
				producers.append(self.dataStore.load(Dealer.self))
			}
			if areas.contains(.Events) {
				producers.append(self.dataStore.load(EventConferenceDay.self))
				producers.append(self.dataStore.load(EventConferenceRoom.self))
				producers.append(self.dataStore.load(EventConferenceTrack.self))
				producers.append(self.dataStore.load(Event.self))
			}

			let overallProgress = Progress(totalUnitCount: Int64(exactly: producers.count + 1)!)
			let resultsProducer = SignalProducer<SignalProducer<DataStoreResult, DataStoreError>, NoError>(producers)

			resultsProducer.flatten(.merge).start({ event in
				switch event {
				case let .value(value):
					print("Value: \(value)")
					switch value.entityType {
					case is Announcement.Type:
						self.Announcements.swap(value.entityData as! [Announcement])
					case is Dealer.Type:
						self.Dealers.swap(value.entityData as! [Dealer])
					case is EventConferenceDay.Type:
						self.EventConferenceDays.swap(value.entityData as! [EventConferenceDay])
					case is EventConferenceRoom.Type:
						self.EventConferenceRooms.swap(value.entityData as! [EventConferenceRoom])
					case is EventConferenceTrack.Type:
						self.EventConferenceTracks.swap(value.entityData as! [EventConferenceTrack])
					case is Event.Type:
						self.Events.swap(value.entityData as! [Event])
					default:
						print("Attempted to load unknown entity") // This should never happen *ducks*
					}
					overallProgress.completedUnitCount += 1
					observer.send(value: overallProgress)
				case let .failed(error):
					print("Failed: \(error)")
					observer.send(error: error)
				case .completed:
					self.navigationResolver.resolve(dataContext: self)
					overallProgress.completedUnitCount += 1
					observer.send(value: overallProgress)
					observer.sendCompleted()
				case .interrupted:
					print("Interrupted")
					observer.sendInterrupted()
				}
			})
		}
	}

	func saveToStore(_ areas: DataContextArea = DataContextArea.All) -> SignalProducer<Progress, DataStoreError> {
		return SignalProducer { observer, disposable in

			var producers: [SignalProducer<DataStoreResult, DataStoreError>] = []

			if areas.contains(.Announcements) {
				producers.append(self.dataStore.save(Announcement.self, entityData: self.Announcements.value))
			}
			if areas.contains(.Dealers) {
				producers.append(self.dataStore.save(Dealer.self, entityData: self.Dealers.value))
			}
			if areas.contains(.Events) {
				producers.append(self.dataStore.save(EventConferenceDay.self, entityData: self.EventConferenceDays.value))
				producers.append(self.dataStore.save(EventConferenceRoom.self, entityData: self.EventConferenceRooms.value))
				producers.append(self.dataStore.save(EventConferenceTrack.self, entityData: self.EventConferenceTracks.value))
				producers.append(self.dataStore.save(Event.self, entityData: self.Events.value))
			}

			let overallProgress = Progress(totalUnitCount: Int64(exactly: producers.count)!)
			let resultsProducer = SignalProducer<SignalProducer<DataStoreResult, DataStoreError>, NoError>(producers)

			resultsProducer.flatten(.merge).start({ event in
				switch event {
				case let .value(value):
					print("Stored entities of type \(String(describing: value.entityType!))")
					overallProgress.completedUnitCount += 1
					observer.send(value: overallProgress)
				case let .failed(error):
					print("Error while storing: \(error)")
					observer.send(error: error)
				case .completed:
					observer.sendCompleted()
				case .interrupted:
					print("Interrupted")
					observer.sendInterrupted()
				}
			})
		}
	}

	func applySync(data: Sync, saveBefore: Bool = true) {
		let overallProgress = Progress(totalUnitCount: 9)
		var affectedAreas: DataContextArea = []

		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.Announcements, syncTarget: Announcements))
		overallProgress.completedUnitCount += 1
		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.Dealers, syncTarget: Dealers))
		overallProgress.completedUnitCount += 1
		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.EventConferenceDays, syncTarget: EventConferenceDays))
		overallProgress.completedUnitCount += 1
		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.EventConferenceRooms, syncTarget: EventConferenceRooms))
		overallProgress.completedUnitCount += 1
		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.EventConferenceTracks, syncTarget: EventConferenceTracks))
		overallProgress.completedUnitCount += 1
		affectedAreas.insert(applySyncEntity(syncEntityDelta: data.Events, syncTarget: Events))
		overallProgress.completedUnitCount += 1

		navigationResolver.resolve(dataContext: self)
		overallProgress.completedUnitCount += 1

		saveToStore(affectedAreas).start()
		overallProgress.completedUnitCount += 1

		refreshedInput.send(value: affectedAreas)
		overallProgress.completedUnitCount += 1
	}

	private func applySyncEntity<EntityType:EntityBase>(syncEntityDelta: SyncEntityDelta<EntityType>, syncTarget: MutableProperty<[EntityType]>) -> DataContextArea {
		var affectedAreas: DataContextArea = []

		if syncEntityDelta.RemoveAllBeforeInsert {
			syncTarget.swap(syncEntityDelta.ChangedEntities)
			affectedAreas.insert(DataContextArea.get(for: EntityType.self))
		} else {
			var updatedEntities: [EntityType] = []
			var updatedEntitiesCount = 0
			for entity in syncTarget.value {
				if let index = syncEntityDelta.ChangedEntities.index(of: entity) {
					updatedEntities.append(syncEntityDelta.ChangedEntities[index])
					updatedEntitiesCount += 1;
				} else if !syncEntityDelta.DeletedEntities.contains(entity.Id) {
					updatedEntities.append(entity)
				} else {
					updatedEntitiesCount += 1;
				}
			}

			if updatedEntitiesCount > 0 {
				syncTarget.swap(updatedEntities)
				affectedAreas.insert(DataContextArea.get(for: EntityType.self))
			}
		}

		return affectedAreas
	}
}
