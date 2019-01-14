//
//  CoreDataEurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import CoreData
import Foundation

public struct CoreDataEurofurenceDataStore: DataStore {

    private class EurofurencePersistentContainer: NSPersistentContainer {
        override class func defaultDirectoryURL() -> URL {
            return FileUtilities.sharedContainerURL.appendingPathComponent("Model")
        }
    }

    // MARK: Properties

    public let container: NSPersistentContainer
    public let storeLocation: URL

    // MARK: Initialization

    public init(storeName: String) {
        container = EurofurencePersistentContainer(name: "EurofurenceApplicationModel")

        storeLocation = EurofurencePersistentContainer.defaultDirectoryURL().appendingPathComponent(storeName)
        let description = NSPersistentStoreDescription(url: storeLocation)
        description.type = NSSQLiteStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, _) in }
    }

    public init() {
        self.init(storeName: "EF24")
    }

    // MARK: DataStore

    public func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
        let context = container.viewContext
        let transaction = CoreDataStoreTransaction()
        block(transaction)
        transaction.performMutations(context: context)

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    public func getSavedKnowledgeGroups() -> [KnowledgeGroupCharacteristics]? {
        return getModels(fetchRequest: KnowledgeGroupEntity.fetchRequest())
    }

    public func getSavedKnowledgeEntries() -> [KnowledgeEntryCharacteristics]? {
        return getModels(fetchRequest: KnowledgeEntryEntity.fetchRequest())
    }

    public func getLastRefreshDate() -> Date? {
        var lastRefreshDate: Date?
        let context = container.viewContext
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<LastRefreshEntity> = LastRefreshEntity.fetchRequest()
                fetchRequest.fetchLimit = 1
                let entity = try fetchRequest.execute()
                if let date = entity.first?.lastRefreshDate {
                    lastRefreshDate = date as Date
                }
            } catch {
                print(error)
            }
        }

        return lastRefreshDate
    }

    public func getSavedRooms() -> [RoomCharacteristics]? {
        return getModels(fetchRequest: RoomEntity.fetchRequest())
    }

    public func getSavedTracks() -> [TrackCharacteristics]? {
        return getModels(fetchRequest: TrackEntity.fetchRequest())
    }

    public func getSavedEvents() -> [EventCharacteristics]? {
        return getModels(fetchRequest: EventEntity.fetchRequest())
    }

    public func getSavedAnnouncements() -> [AnnouncementCharacteristics]? {
        return getModels(fetchRequest: AnnouncementEntity.fetchRequest())
    }

    public func getSavedConferenceDays() -> [ConferenceDayCharacteristics]? {
        return getModels(fetchRequest: ConferenceDayEntity.fetchRequest())
    }

    public func getSavedFavouriteEventIdentifiers() -> [EventIdentifier]? {
        return getModels(fetchRequest: FavouriteEventEntity.fetchRequest())
    }

    public func getSavedDealers() -> [DealerCharacteristics]? {
        return getModels(fetchRequest: DealerEntity.fetchRequest())
    }

    public func getSavedMaps() -> [MapCharacteristics]? {
        return getModels(fetchRequest: MapEntity.fetchRequest())
    }

    public func getSavedReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]? {
        return getModels(fetchRequest: ReadAnnouncementEntity.fetchRequest())
    }

    public func getSavedImages() -> [ImageCharacteristics]? {
        return getModels(fetchRequest: ImageModelEntity.fetchRequest())
    }

    // MARK: Private

    private func getModels<Entity>(fetchRequest: NSFetchRequest<Entity>) -> [Entity.AdaptedType]? where Entity: EntityAdapting {
        var models: [Entity.AdaptedType]?
        let context = container.viewContext
        context.performAndWait {
            do {
                let entities = try fetchRequest.execute()
                models = entities.map({ $0.asAdaptedType() })
            } catch {
                print(error)
            }
        }

        return models
    }

}
