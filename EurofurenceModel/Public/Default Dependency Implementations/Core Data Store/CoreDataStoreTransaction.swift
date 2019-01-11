//
//  CoreDataStoreTransaction.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 10/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStoreTransaction: DataStoreTransaction {

    // MARK: Properties

    private var mutations = [(NSManagedObjectContext) -> Void]()

    // MARK: Functions

    func performMutations(context: NSManagedObjectContext) {
        context.performAndWait {
            mutations.forEach { $0(context) }
        }
    }

    // MARK: DataStoreTransaction

    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        mutations.append { (context) in
            let fetchRequestForExistingRefreshDate: NSFetchRequest<LastRefreshEntity> = LastRefreshEntity.fetchRequest()

            do {
                let existingEntities = try fetchRequestForExistingRefreshDate.execute()
                existingEntities.forEach(context.delete)
            } catch {
                print(error)
            }

            let entity = LastRefreshEntity(context: context)
            entity.lastRefreshDate = lastRefreshDate
        }
    }

    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
        updateEntities(ofKind: KnowledgeGroupEntity.self, using: knowledgeGroups)
    }

    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {
        mutations.append { (context) in
            knowledgeEntries.forEach { (entry) in
                let predicate = KnowledgeEntryEntity.makeIdentifyingPredicate(for: entry)
                let entity: KnowledgeEntryEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                entity.links.let(entity.removeFromLinks)

                let links = entry.links.map { (link) -> LinkEntity in
                    let predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)
                    let entity: LinkEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                    entity.consumeAttributes(from: link)

                    return entity
                }

                entity.consumeAttributes(from: entry)
                links.forEach(entity.addToLinks)
            }
        }
    }

    func saveAnnouncements(_ announcements: [APIAnnouncement]) {
        updateEntities(ofKind: AnnouncementEntity.self, using: announcements)
    }

    func saveEvents(_ events: [APIEvent]) {
        updateEntities(ofKind: EventEntity.self, using: events)
    }

    func saveRooms(_ rooms: [APIRoom]) {
        updateEntities(ofKind: RoomEntity.self, using: rooms)
    }

    func saveTracks(_ tracks: [APITrack]) {
        updateEntities(ofKind: TrackEntity.self, using: tracks)
    }

    func saveConferenceDays(_ conferenceDays: [APIConferenceDay]) {
        updateEntities(ofKind: ConferenceDayEntity.self, using: conferenceDays)
    }

    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        updateEntities(ofKind: FavouriteEventEntity.self, using: [identifier])
    }

    func saveDealers(_ dealers: [APIDealer]) {
        mutations.append { (context) in
            dealers.forEach { (dealer) in
                let predicate = DealerEntity.makeIdentifyingPredicate(for: dealer)
                let entity: DealerEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                entity.consumeAttributes(from: dealer)

                let links = dealer.links?.map { (link) -> LinkEntity in
                    let predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)
                    let entity: LinkEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                    entity.consumeAttributes(from: link)

                    return entity
                }

                links?.forEach(entity.addToLinks)
            }
        }
    }

    func saveMaps(_ maps: [APIMap]) {
        mutations.append { (context) in
            maps.forEach { (map) in
                let predicate = MapEntity.makeIdentifyingPredicate(for: map)
                let entity: MapEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                entity.consumeAttributes(from: map)
                entity.entries.let(entity.removeFromEntries)

                let entries = map.entries.map { (entry) -> MapEntryEntity in
                    let links = entry.links.map { (link) -> MapEntryLinkEntity in
                        let entity = MapEntryLinkEntity(context: context)
                        entity.consumeAttributes(from: link)

                        return entity
                    }

                    let entity = MapEntryEntity(context: context)
                    entity.consumeAttributes(from: entry)
                    links.forEach(entity.addToLinks)

                    return entity
                }

                entries.forEach(entity.addToEntries)
            }
        }
    }

    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        updateEntities(ofKind: ReadAnnouncementEntity.self, using: announcements)
    }

    func saveImages(_ images: [APIImage]) {
        updateEntities(ofKind: ImageModelEntity.self, using: images)
    }

    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<FavouriteEventEntity> = FavouriteEventEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "eventIdentifier == %@", identifier.rawValue)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteKnowledgeGroup(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<KnowledgeGroupEntity> = KnowledgeGroupEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteKnowledgeEntry(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<KnowledgeEntryEntity> = KnowledgeEntryEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteAnnouncement(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<AnnouncementEntity> = AnnouncementEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteEvent(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteTrack(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteRoom(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteConferenceDay(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<ConferenceDayEntity> = ConferenceDayEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteDealer(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<DealerEntity> = DealerEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteMap(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<MapEntity> = MapEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    func deleteImage(identifier: String) {
        mutations.append { (context) in
            let fetchRequest: NSFetchRequest<ImageModelEntity> = ImageModelEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            fetchRequest.fetchLimit = 1

            context.deleteFirstMatch(for: fetchRequest)
        }
    }

    // MARK: Private

    private func updateEntities<E: NSManagedObject & EntityAdapting>(ofKind entityType: E.Type, using models: [E.AdaptedType]) {
        mutations.append { (context) in
            models.forEach { (model) in
                let entity: E = context.makeEntity(uniquelyIdentifiedBy: E.makeIdentifyingPredicate(for: model))
                entity.consumeAttributes(from: model)
            }
        }
    }

}
