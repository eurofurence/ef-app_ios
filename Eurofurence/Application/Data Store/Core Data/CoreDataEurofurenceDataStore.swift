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

    private let container: NSPersistentContainer

    let storeLocation: URL

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

    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        struct Transaction: EurofurenceDataStoreTransaction {

            var context: NSManagedObjectContext

            func saveLastRefreshDate(_ lastRefreshDate: Date) {

            }

            func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
                knowledgeGroups.forEach { (group) in
                    let entity = KnowledgeGroupEntity(context: context)
                    entity.identifier = group.identifier
                    entity.order = Int64(group.order)
                    entity.groupName = group.groupName
                    entity.groupDescription = group.groupDescription
                }
            }

            func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {

            }

            func saveAnnouncements(_ announcements: [APIAnnouncement]) {

            }

            func saveEvents(_ events: [APIEvent]) {

            }

            func saveRooms(_ rooms: [APIRoom]) {

            }

            func saveTracks(_ tracks: [APITrack]) {

            }

        }

        let context = container.viewContext
        let transaction = Transaction(context: context)
        block(transaction)

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]? {
        var groups: [APIKnowledgeGroup]?
        let fetchRequest: NSFetchRequest<KnowledgeGroupEntity> = KnowledgeGroupEntity.fetchRequest()
        let context = container.viewContext
        context.performAndWait {
            do {
                let entities = try fetchRequest.execute()
                groups = entities.map { (entity) -> APIKnowledgeGroup in
                    return APIKnowledgeGroup(identifier: entity.identifier!,
                                             order: Int(entity.order),
                                             groupName: entity.groupName!,
                                             groupDescription: entity.groupDescription!)
                }
            } catch {
                print(error)
            }
        }

        return groups
    }

    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]? {
        return nil
    }

    func getLastRefreshDate() -> Date? {
        return nil
    }

    func getSavedRooms() -> [APIRoom]? {
        return nil
    }

    func getSavedTracks() -> [APITrack]? {
        return nil
    }

    func getSavedEvents() -> [APIEvent]? {
        return nil
    }

}
