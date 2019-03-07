//
//  CoreDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import CoreData
import Foundation

public struct CoreDataStore: DataStore {

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

    public func fetchKnowledgeGroups() -> [KnowledgeGroupCharacteristics]? {
        return getModels(fetchRequest: KnowledgeGroupEntity.fetchRequest())
    }

    public func fetchKnowledgeEntries() -> [KnowledgeEntryCharacteristics]? {
        return getModels(fetchRequest: KnowledgeEntryEntity.fetchRequest())
    }

    public func fetchLastRefreshDate() -> Date? {
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

    public func fetchRooms() -> [RoomCharacteristics]? {
        return getModels(fetchRequest: RoomEntity.fetchRequest())
    }

    public func fetchTracks() -> [TrackCharacteristics]? {
        return getModels(fetchRequest: TrackEntity.fetchRequest())
    }

    public func fetchEvents() -> [EventCharacteristics]? {
        return getModels(fetchRequest: EventEntity.fetchRequest())
    }

    public func fetchAnnouncements() -> [AnnouncementCharacteristics]? {
        return getModels(fetchRequest: AnnouncementEntity.fetchRequest())
    }

    public func fetchConferenceDays() -> [ConferenceDayCharacteristics]? {
        return getModels(fetchRequest: ConferenceDayEntity.fetchRequest())
    }

    public func fetchFavouriteEventIdentifiers() -> [EventIdentifier]? {
        return getModels(fetchRequest: FavouriteEventEntity.fetchRequest())
    }

    public func fetchDealers() -> [DealerCharacteristics]? {
        return getModels(fetchRequest: DealerEntity.fetchRequest())
    }

    public func fetchMaps() -> [MapCharacteristics]? {
        return getModels(fetchRequest: MapEntity.fetchRequest())
    }

    public func fetchReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]? {
        return getModels(fetchRequest: ReadAnnouncementEntity.fetchRequest())
    }

    public func fetchImages() -> [ImageCharacteristics]? {
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
