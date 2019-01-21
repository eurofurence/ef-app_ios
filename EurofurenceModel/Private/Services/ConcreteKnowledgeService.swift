//
//  ConcreteKnowledgeService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteKnowledgeService: KnowledgeService {

    // MARK: Properties

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private var observers = [KnowledgeServiceObserver]()
    var models = [KnowledgeGroup]() {
        didSet {
            observers.forEach { $0.knowledgeGroupsDidChange(to: models) }
        }
    }

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: DataStore, imageRepository: ImageRepository) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadKnowledgeBaseFromDataStore))

        reloadKnowledgeBaseFromDataStore()
    }

    // MARK: Functions

    func add(_ observer: KnowledgeServiceObserver) {
        observers.append(observer)
        observer.knowledgeGroupsDidChange(to: models)
    }

    func fetchKnowledgeEntry(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntry) -> Void) {
        models.reduce([], { $0 + $1.entries }).first(where: { $0.identifier == identifier }).let(completionHandler)
    }

    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroup) -> Void) {
        models.first(where: { $0.identifier == identifier }).let(completionHandler)
    }

    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier, completionHandler: @escaping ([Data]) -> Void) {
        let imageIdentifiers: [String] = {
            guard let entries = dataStore.fetchKnowledgeEntries() else { return [] }
            guard let entry = entries.first(where: { $0.identifier == identifier.rawValue }) else { return [] }

            return entry.imageIdentifiers
        }()

        let images = imageIdentifiers.compactMap(imageRepository.loadImage).map({ $0.pngImageData })
        completionHandler(images)
    }

    // MARK: Private

    private func reloadKnowledgeBaseFromDataStore() {
        guard let groups = dataStore.fetchKnowledgeGroups(),
              let entries = dataStore.fetchKnowledgeEntries() else {
                return
        }

        models = KnowledgeGroup.fromServerModels(groups: groups, entries: entries)
    }

}
