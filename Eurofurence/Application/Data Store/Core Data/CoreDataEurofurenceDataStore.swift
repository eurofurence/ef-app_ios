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

    private class EurofurencePersistentContainer: NSPersistentContainer {
        override class func defaultDirectoryURL() -> URL {
            return FileUtilities.sharedContainerURL.appendingPathComponent("Model")
        }
    }

    // MARK: Properties

    let container: NSPersistentContainer
    let storeLocation: URL

    // MARK: Initialization

    init(storeName: String) {
        container = EurofurencePersistentContainer(name: "EurofurenceApplicationModel")

        storeLocation = EurofurencePersistentContainer.defaultDirectoryURL().appendingPathComponent(storeName)
        let description = NSPersistentStoreDescription(url: storeLocation)
        description.type = NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, _) in }
    }

    init() {
        self.init(storeName: "EF24")
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

    func getSavedConferenceDays() -> [APIConferenceDay]? {
        return getModels(fetchRequest: ConferenceDayEntity.fetchRequest())
    }

    func getSavedFavouriteEventIdentifiers() -> [Event2.Identifier]? {
        return getModels(fetchRequest: FavouriteEventEntity.fetchRequest())
    }

    func getSavedDealers() -> [APIDealer]? {
        return getModels(fetchRequest: DealerEntity.fetchRequest())
    }

    func getSavedMaps() -> [APIMap]? {
        return getModels(fetchRequest: MapEntity.fetchRequest())
    }

    func getSavedReadAnnouncementIdentifiers() -> [Announcement2.Identifier]? {
        return getModels(fetchRequest: ReadAnnouncementEntity.fetchRequest())
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
                entity.lastRefreshDate = lastRefreshDate
            }
        }

        func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
            mutations.append { (context) in
                knowledgeGroups.forEach { (group) in
                    let entity: KnowledgeGroupEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: group.identifier)

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
                    let entity: KnowledgeEntryEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: entry.identifier)

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
                    let entity: AnnouncementEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: announcement.identifier)
                    entity.identifier = announcement.identifier
                    entity.title = announcement.title
                    entity.content = announcement.content
                    entity.lastChangedDateTime = announcement.lastChangedDateTime
                }
            }
        }

        func saveEvents(_ events: [APIEvent]) {
            mutations.append { (context) in
                events.forEach { (event) in
                    let entity: EventEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: event.identifier)

                    entity.identifier = event.identifier
                    entity.roomIdentifier = event.roomIdentifier
                    entity.trackIdentifier = event.trackIdentifier
                    entity.dayIdentifier = event.dayIdentifier
                    entity.startDateTime = event.startDateTime
                    entity.endDateTime = event.endDateTime
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
                    let entity: RoomEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: room.roomIdentifier)
                    entity.identifier = room.roomIdentifier
                    entity.name = room.name
                }
            }
        }

        func saveTracks(_ tracks: [APITrack]) {
            mutations.append { (context) in
                tracks.forEach { (track) in
                    let entity: TrackEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: track.trackIdentifier)
                    entity.identifier = track.trackIdentifier
                    entity.name = track.name
                }
            }
        }

        func saveConferenceDays(_ conferenceDays: [APIConferenceDay]) {
            mutations.append { (context) in
                conferenceDays.forEach { (conferenceDay) in
                    let entity: ConferenceDayEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: conferenceDay.identifier)
                    entity.identifier = conferenceDay.identifier
                    entity.date = conferenceDay.date
                }
            }
        }

        func saveFavouriteEventIdentifier(_ identifier: Event2.Identifier) {
            mutations.append { (context) in
                let favouriteEventIdentifierPredicate = NSPredicate(format: "eventIdentifier == %@", identifier.rawValue)
                let entity: FavouriteEventEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: favouriteEventIdentifierPredicate)
                entity.eventIdentifier = identifier.rawValue
            }
        }

        func deleteFavouriteEventIdentifier(_ identifier: Event2.Identifier) {
            mutations.append { (context) in
                let fetchRequest: NSFetchRequest<FavouriteEventEntity> = FavouriteEventEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "eventIdentifier == %@", identifier.rawValue)
                fetchRequest.fetchLimit = 1

                do {
                    let results = try fetchRequest.execute()
                    if let result = results.first {
                        context.delete(result)
                    }
                } catch {
                    print(error)
                }
            }
        }

        func saveDealers(_ dealers: [APIDealer]) {
            mutations.append { (context) in
                dealers.forEach { (dealer) in
                    let entity: DealerEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: dealer.identifier)
                    entity.identifier = dealer.identifier
                    entity.displayName = dealer.displayName
                    entity.attendeeNickname = dealer.attendeeNickname
                    entity.attendsOnThursday = dealer.attendsOnThursday
                    entity.attendsOnFriday = dealer.attendsOnFriday
                    entity.attendsOnSaturday = dealer.attendsOnSaturday
                    entity.isAfterDark = dealer.isAfterDark
                    entity.artistThumbnailImageId = dealer.artistThumbnailImageId
                    entity.artistImageId = dealer.artistImageId
                    entity.artPreviewImageId = dealer.artPreviewImageId
                    entity.categories = dealer.categories
                    entity.dealerShortDescription = dealer.shortDescription
                    entity.twitterHandle = dealer.twitterHandle
                    entity.telegramHandle = dealer.telegramHandle
                    entity.aboutTheArtist = dealer.aboutTheArtistText
                    entity.aboutTheArtText = dealer.aboutTheArtText
                    entity.artPreviewCaption = dealer.artPreviewCaption

                    let links = dealer.links?.map { (link) -> LinkEntity in
                        let predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)
                        let entity: LinkEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: predicate)
                        entity.name = link.name
                        entity.target = link.target
                        entity.fragmentType = Int16(link.fragmentType.rawValue)

                        return entity
                    }

                    links?.forEach(entity.addToLinks)
                }
            }
        }

        func saveMaps(_ maps: [APIMap]) {
            mutations.append { (context) in
                maps.forEach { (map) in
                    let entity: MapEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: map.identifier)
                    entity.identifier = map.identifier
                    entity.imageIdentifier = map.imageIdentifier
                    entity.mapDescription = map.mapDescription

                    let entries = map.entries.map { (entry) -> MapEntryEntity in
                        let links = entry.links.map { (link) -> MapEntryLinkEntity in
                            let entity = MapEntryLinkEntity(context: context)
                            entity.type = Int16(link.type.rawValue)
                            entity.name = link.name
                            entity.target = link.target

                            return entity
                        }

                        let entity = MapEntryEntity(context: context)
                        entity.x = Int64(entry.x)
                        entity.y = Int64(entry.y)
                        entity.tapRadius = Int64(entry.tapRadius)
                        links.forEach(entity.addToLinks)

                        return entity
                    }

                    entries.forEach(entity.addToEntries)
                }
            }
        }

        func saveReadAnnouncements(_ announcements: [Announcement2.Identifier]) {
            mutations.append { (context) in
                announcements.forEach { (announcement) in
                    let announcementIdentifierPredicate = NSPredicate(format: "announcementIdentifier == %@", announcement.rawValue)
                    let entity: ReadAnnouncementEntity = self.makeEntity(in: context, uniquelyIdentifiedBy: announcementIdentifierPredicate)
                    entity.announcementIdentifier = announcement.rawValue
                }
            }
        }

        // MARK: Private

        private func makeEntity<Entity>(in context: NSManagedObjectContext,
                                        uniquelyIdentifiedBy identifier: String) -> Entity where Entity: NSManagedObject {
            let predicate = NSPredicate(format: "identifier == %@", identifier)
            return makeEntity(in: context, uniquelyIdentifiedBy: predicate)
        }

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
