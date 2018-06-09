//
//  CoreDataEurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import CoreData
import Foundation

struct CoreDataEurofurenceDataStore: EurofurenceDataStore {

    // MARK: Properties

    let container: NSPersistentContainer
    let storeLocation: URL

    // MARK: Initialization

    init(storeName: String) {
        container = NSPersistentContainer(name: "EurofurenceApplicationModel")

        storeLocation = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(storeName)
        let description = NSPersistentStoreDescription(url: storeLocation)
        description.type = NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, _) in }
    }

    init() {
        self.init(storeName: "Application")
    }

    // MARK: EurofurenceDataStore

    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        let context = container.viewContext
        let transaction = Transaction()
        block(transaction)
        transaction.performMutations(context: context)

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]? {
        return getModels(fetchRequest: KnowledgeGroupEntity.fetchRequest())
    }

    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]? {
        return getModels(fetchRequest: KnowledgeEntryEntity.fetchRequest())
    }

    func getLastRefreshDate() -> Date? {
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

    func getSavedRooms() -> [APIRoom]? {
        return getModels(fetchRequest: RoomEntity.fetchRequest())
    }

    func getSavedTracks() -> [APITrack]? {
        return getModels(fetchRequest: TrackEntity.fetchRequest())
    }

    func getSavedEvents() -> [APIEvent]? {
        return getModels(fetchRequest: EventEntity.fetchRequest())
    }

    func getSavedAnnouncements() -> [APIAnnouncement]? {
        return getModels(fetchRequest: AnnouncementEntity.fetchRequest())
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

    class Transaction: EurofurenceDataStoreTransaction {

        // MARK: Properties

        private var mutations = [(NSManagedObjectContext) -> Void]()

        // MARK: Functions

        func performMutations(context: NSManagedObjectContext) {
            context.performAndWait {
                mutations.forEach { $0(context) }
            }
        }

        // MARK: EurofurenceDataStoreTransaction

        func saveLastRefreshDate(_ lastRefreshDate: Date) {
            mutations.append { (context) in
                let entity = LastRefreshEntity(context: context)
                entity.lastRefreshDate = lastRefreshDate as NSDate
            }
        }

        func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
            mutations.append { (context) in
                knowledgeGroups.forEach { (group) in
                    let predicate = NSPredicate(format: "\(#keyPath(KnowledgeGroupEntity.identifier)) == %@", group.identifier)
                    let entity: KnowledgeGroupEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: predicate)

                    entity.identifier = group.identifier
                    entity.order = Int64(group.order)
                    entity.groupName = group.groupName
                    entity.groupDescription = group.groupDescription
                }
            }
        }

        func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {
            mutations.append { (context) in
                knowledgeEntries.forEach { (entry) in
                    let predicate = NSPredicate(format: "\(#keyPath(KnowledgeEntryEntity.identifier)) == %@", entry.identifier)
                    let entity: KnowledgeEntryEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: predicate)

                    let links = entry.links.map { (link) -> LinkEntity in
                        let predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)
                        let entity: LinkEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: predicate)
                        entity.name = link.name
                        entity.target = link.target
                        entity.fragmentType = Int16(link.fragmentType.rawValue)

                        return entity
                    }

                    entity.identifier = entry.identifier
                    entity.title = entry.title
                    entity.text = entry.text
                    entity.groupIdentifier = entry.groupIdentifier
                    entity.order = Int64(entry.order)
                    links.forEach(entity.addToLinks)
                }
            }
        }

        func saveAnnouncements(_ announcements: [APIAnnouncement]) {
            mutations.append { (context) in
                announcements.forEach { (announcement) in
                    let entity = AnnouncementEntity(context: context)
                    entity.identifier = announcement.identifier
                    entity.title = announcement.title
                    entity.content = announcement.content
                    entity.lastChangedDateTime = announcement.lastChangedDateTime as NSDate
                }
            }
        }

        func saveEvents(_ events: [APIEvent]) {
            mutations.append { (context) in
                events.forEach { (event) in
                    let entity = EventEntity(context: context)
                    entity.identifier = event.identifier
                    entity.roomIdentifier = event.roomIdentifier
                    entity.trackIdentifier = event.trackIdentifier
                    entity.startDateTime = event.startDateTime as NSDate
                    entity.endDateTime = event.endDateTime as NSDate
                    entity.title = event.title
                    entity.abstract = event.abstract
                    entity.panelHosts = event.panelHosts
                    entity.eventDescription = event.eventDescription
                    entity.posterImageId = event.posterImageId
                    entity.bannerImageId = event.bannerImageId
                }
            }
        }

        func saveRooms(_ rooms: [APIRoom]) {
            mutations.append { (context) in
                rooms.forEach { (room) in
                    let entity = RoomEntity(context: context)
                    entity.identifier = room.roomIdentifier
                    entity.name = room.name
                }
            }
        }

        func saveTracks(_ tracks: [APITrack]) {
            mutations.append { (context) in
                tracks.forEach { (track) in
                    let entity = TrackEntity(context: context)
                    entity.identifier = track.trackIdentifier
                    entity.name = track.name
                }
            }
        }

        // MARK: Private

        private func makeEntity<Entity>(in context: NSManagedObjectContext,
                                        uniquelyIdentifiedBy predicate: NSPredicate) -> Entity where Entity: NSManagedObject {
            let fetchRequest = Entity.fetchRequest() as? NSFetchRequest<Entity>
            fetchRequest?.fetchLimit = 1
            fetchRequest?.predicate = predicate

            let entity: Entity
            do {
                let results = try fetchRequest?.execute()
                if let result = results?.first {
                    entity = result
                } else {
                    entity = Entity(context: context)
                }
            } catch {
                entity = Entity(context: context)
            }

            return entity
        }

    }

}
