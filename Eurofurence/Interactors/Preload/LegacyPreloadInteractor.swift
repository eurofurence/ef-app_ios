//
//  LegacyPreloadInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class LegacyPreloadInteractor: PreloadInteractor,
                               DataStoreLoadDelegate,
                               DataStoreRefreshDelegate {

    private lazy var loadController = DataStoreLoadController.shared
    private lazy var refreshController = DataStoreRefreshController.shared
    private var delegates = [PreloadInteractorDelegate]()

    init() {
        loadController.add(self, doPrepend: true)
        refreshController.add(self, doPrepend: true)
    }

    func beginPreloading(delegate: PreloadInteractorDelegate) {
        delegates.append(delegate)
        loadController.loadFromStore()
    }

    func dataStoreLoadDidBegin() {

    }

    func dataStoreLoadDidProduceProgress(_ progress: Progress) {
        notifyDelegatesOfProgress(progress)
    }

    func dataStoreLoadDidFinish() {
        notifyFinishedAndClearDelegates()
    }

    func dataStoreRefreshDidBegin(_ lastSync: Date?) {

    }

    func dataStoreRefreshDidFinish() {
        notifyFinishedAndClearDelegates()
    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        delegates.forEach({ $0.preloadInteractorDidFailToPreload() })
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {
        notifyDelegatesOfProgress(progress)
    }

    private func notifyDelegatesOfProgress(_ progress: Progress) {
        delegates.forEach({ $0.preloadInteractorDidProgress(currentUnitCount: Int(progress.completedUnitCount), totalUnitCount: Int(progress.totalUnitCount), localizedDescription: "") })
    }

    private func notifyFinishedAndClearDelegates() {
        delegates.forEach({ $0.preloadInteractorDidFinishPreloading() })
        delegates.removeAll()
    }

}
