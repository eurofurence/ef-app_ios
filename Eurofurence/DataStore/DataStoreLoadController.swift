//
//  DataStoreLoadController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol DataStoreLoadDelegate {

    func dataStoreLoadDidBegin()
    func dataStoreRefreshDidProduceProgress(_ progress: Progress)
    func dataStoreLoadDidFinish()

}

class DataStoreLoadController {

    static let shared = DataStoreLoadController()

    private let dataContext: DataContextProtocol
    private var delegates = [DataStoreLoadDelegate]()

    private init() {
        dataContext = try! ContextResolver.container.resolve() as DataContextProtocol
    }

    func add(_ delegate: DataStoreLoadDelegate) {
        delegates.append(delegate)
    }

    func loadFromStore() {
        delegates.forEach({ $0.dataStoreLoadDidBegin() })

        dataContext
            .loadFromStore()
            .start(on: QueueScheduler.concurrent)
            .observe(on: QueueScheduler.main)
            .start({ event in
            switch event {
            case let .value(value):
                self.delegates.forEach({ $0.dataStoreRefreshDidProduceProgress(value) })
            case let .failed(error):
                print("Failed to load data from store: \(error)")

                // TODO: Prompt user for required initialisation
                // TODO: Check WiFi connection and prompt user if on mobile
                print("Performing full reload from API")
                DataStoreRefreshController.shared.refreshStore()
            case .completed:
                self.delegates.forEach({ $0.dataStoreLoadDidFinish() })

                print("Loading completed")
                // TODO: Check WiFi connection and prompt user if on mobile
                if UserSettings.UpdateOnStart.currentValueOrDefault() {
                    DataStoreRefreshController.shared.refreshStore()
                }
            case .interrupted:
                print("Loading interrupted")
            }
        })
    }

}
