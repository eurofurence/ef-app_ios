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
                knowledgeEntries.forEach { (entry) in
                    let links = entry.links.map { (link) -> LinkEntity in
                        let entity = LinkEntity(context: context)
                        entity.name = link.name
                        entity.target = link.target
                        entity.fragmentType = Int16(link.fragmentType.rawValue)

                        return entity
                    }

                    let entity = KnowledgeEntryEntity(context: context)
                    entity.title = entry.title
                    entity.text = entry.text
                    entity.groupIdentifier = entry.groupIdentifier
                    entity.order = Int64(entry.order)
                    links.forEach(entity.addToLinks)
                }
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
        var entries: [APIKnowledgeEntry]?
        let fetchRequest: NSFetchRequest<KnowledgeEntryEntity> = KnowledgeEntryEntity.fetchRequest()
        let context = container.viewContext
        context.performAndWait {
            do {
                let entities = try fetchRequest.execute()
                entries = entities.map { (entity) -> APIKnowledgeEntry in
                    var links: [APILink] = []
                    if let entryLinks = entity.links as? Set<LinkEntity> {
                        links = entryLinks.map { (entity) -> APILink in
                            return APILink(name: entity.name!,
                                           fragmentType: APILink.FragmentType(rawValue: Int(entity.fragmentType))!,
                                           target: entity.target!)
                        }

                        links.sort()
                    }

                    return APIKnowledgeEntry(groupIdentifier: entity.groupIdentifier!,
                                             title: entity.title!,
                                             order: Int(entity.order),
                                             text: entity.text!,
                                             links: links)
                }
            } catch {
                print(error)
            }
        }

        return entries
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
