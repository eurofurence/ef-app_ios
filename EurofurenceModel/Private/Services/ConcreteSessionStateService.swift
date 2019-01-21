//
//  ConcreteSessionStateService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct ConcreteSessionStateService: SessionStateService {

    var forceRefreshRequired: ForceRefreshRequired
    var userPreferences: UserPreferences
    var dataStore: DataStore

    func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void) {
        let shouldPerformForceRefresh: Bool = forceRefreshRequired.isForceRefreshRequired
        let state: EurofurenceSessionState = {
            guard dataStore.fetchLastRefreshDate() != nil else { return .uninitialized }

            let dataStoreStale = shouldPerformForceRefresh || userPreferences.refreshStoreOnLaunch
            return dataStoreStale ? .stale : .initialized
        }()

        completionHandler(state)
    }

}
