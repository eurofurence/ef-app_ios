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

    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        updateEntities(ofKind: KnowledgeGroupEntity.self, using: knowledgeGroups)
    }

    func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        mutations.append { (context) in
            knowledgeEntries.forEach { (entry) in
                let predicate = KnowledgeEntryEntity.makeIdentifyingPredicate(for: entry)
                let entity: KnowledgeEntryEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                entity.links.let(entity.removeFromLinks)

                let links = entry.links.map { (link) -> LinkEntity in
                    let namePredicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@", link.name)
                    let targetPredicate = NSPredicate(format: "\(#keyPath(LinkEntity.target)) == %@", link.target)
                    let fragmentPredicate = NSPredicate(
                        format: "\(#keyPath(LinkEntity.fragmentType)) == %li",
                        link.fragmentType.rawValue
                    )
                    
                    let predicate = NSCompoundPredicate(
                        andPredicateWithSubpredicates: [namePredicate, targetPredicate, fragmentPredicate]
                    )
                    
                    let entity: LinkEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                    entity.consumeAttributes(from: link)

                    return entity
                }

                entity.consumeAttributes(from: entry)
                links.forEach(entity.addToLinks)
            }
        }
    }

    func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        updateEntities(ofKind: AnnouncementEntity.self, using: announcements)
    }

    func saveEvents(_ events: [EventCharacteristics]) {
        updateEntities(ofKind: EventEntity.self, using: events)
    }

    func saveRooms(_ rooms: [RoomCharacteristics]) {
        updateEntities(ofKind: RoomEntity.self, using: rooms)
    }

    func saveTracks(_ tracks: [TrackCharacteristics]) {
        updateEntities(ofKind: TrackEntity.self, using: tracks)
    }

    func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        updateEntities(ofKind: ConferenceDayEntity.self, using: conferenceDays)
    }

    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        updateEntities(ofKind: FavouriteEventEntity.self, using: [identifier])
    }

    func saveDealers(_ dealers: [DealerCharacteristics]) {
        mutations.append { (context) in
            dealers.forEach { (dealer) in
                let predicate = DealerEntity.makeIdentifyingPredicate(for: dealer)
                let entity: DealerEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                entity.consumeAttributes(from: dealer)

                let links = dealer.links?.map { (link) -> LinkEntity in
                    let namePredicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@", link.name)
                    let targetPredicate = NSPredicate(format: "\(#keyPath(LinkEntity.target)) == %@", link.target)
                    let fragmentPredicate = NSPredicate(
                        format: "\(#keyPath(LinkEntity.fragmentType)) == %li",
                        link.fragmentType.rawValue
                    )
                    
                    let predicate = NSCompoundPredicate(
                        andPredicateWithSubpredicates: [namePredicate, targetPredicate, fragmentPredicate]
                    )
                    
                    let entity: LinkEntity = context.makeEntity(uniquelyIdentifiedBy: predicate)
                    entity.consumeAttributes(from: link)

                    return entity
                }

                links?.forEach(entity.addToLinks)
            }
        }
    }

    func saveMaps(_ maps: [MapCharacteristics]) {
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

    func saveImages(_ images: [ImageCharacteristics]) {
        updateEntities(ofKind: ImageModelEntity.self, using: images)
    }

    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        deleteFirst(FavouriteEventEntity.self, identifierKey: "eventIdentifier", identifier: identifier.rawValue)
    }

    func deleteKnowledgeGroup(identifier: String) {
        deleteFirst(KnowledgeGroupEntity.self, identifier: identifier)
    }

    func deleteKnowledgeEntry(identifier: String) {
        deleteFirst(KnowledgeEntryEntity.self, identifier: identifier)
    }

    func deleteAnnouncement(identifier: String) {
        deleteFirst(AnnouncementEntity.self, identifier: identifier)
    }

    func deleteEvent(identifier: String) {
        deleteFirst(EventEntity.self, identifier: identifier)
    }

    func deleteTrack(identifier: String) {
        deleteFirst(TrackEntity.self, identifier: identifier)
    }

    func deleteRoom(identifier: String) {
        deleteFirst(RoomEntity.self, identifier: identifier)
    }

    func deleteConferenceDay(identifier: String) {
        deleteFirst(ConferenceDayEntity.self, identifier: identifier)
    }

    func deleteDealer(identifier: String) {
        deleteFirst(DealerEntity.self, identifier: identifier)
    }

    func deleteMap(identifier: String) {
        deleteFirst(MapEntity.self, identifier: identifier)
    }

    func deleteImage(identifier: String) {
        deleteFirst(ImageModelEntity.self, identifier: identifier)
    }

    // MARK: Private

    private func updateEntities<E: NSManagedObject & EntityAdapting>(
        ofKind entityType: E.Type,
        using models: [E.AdaptedType]
    ) {
        mutations.append { (context) in
            models.forEach { (model) in
                let entity: E = context.makeEntity(uniquelyIdentifiedBy: E.makeIdentifyingPredicate(for: model))
                entity.consumeAttributes(from: model)
            }
        }
    }
    
    private func deleteFirst<T>(_ kind: T.Type,
                                identifierKey: String = "identifier",
                                identifier: String) where T: NSManagedObject {
        mutations.append { (context) in
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
            fetchRequest.predicate = NSPredicate(format: "\(identifierKey) == %@", identifier)
            fetchRequest.fetchLimit = 1
            context.deleteFirstMatch(for: fetchRequest)
        }
    }

}
