//
//  DataStoreRefreshController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol DataStoreRefreshDelegate {

    func dataStoreRefreshDidBegin()
    func dataStoreRefreshDidFinish()
    func dataStoreRefreshDidFailWithError(_ error: Error)
    func dataStoreRefreshDidProduceProgress(_ progress: Progress)

}

class DataStoreRefreshController {

    static let shared = DataStoreRefreshController()

    private let contextManager: ContextManager
    private var refreshingDelegates = [DataStoreRefreshDelegate]()
    private var isRefreshing = false

    private init() {
        contextManager = try! ContextResolver.container.resolve()
    }

    func add(_ delegate: DataStoreRefreshDelegate) {
        refreshingDelegates.append(delegate)

        if isRefreshing {
            delegate.dataStoreRefreshDidBegin()
        }
    }

    func refreshStore() {
        guard !isRefreshing else { return }

        isRefreshing = true
        refreshingDelegates.forEach({ $0.dataStoreRefreshDidBegin() })

        contextManager
            .syncWithApi?
            .apply(UserSettings.LastSyncDate.currentValue())
            .observe(on: QueueScheduler.main)
            .start { result in
                if result.isCompleted {
                    self.isRefreshing = false
                    self.refreshingDelegates.forEach({ $0.dataStoreRefreshDidFinish() })
                } else if let value = result.value {
                    self.refreshingDelegates.forEach({ $0.dataStoreRefreshDidProduceProgress(value) })
                } else if let error = result.error {
                    self.isRefreshing = false
                    self.refreshingDelegates.forEach({ $0.dataStoreRefreshDidFailWithError(error) })
                }
            }
    }

}
