//
//  StubDataStoreFactory.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles

struct StubDataStoreFactory: DataStoreFactory {
    
    var conventionIdentifier: ConventionIdentifier
    var dataStore: DataStore
    
    func makeDataStore(for conventionIdentifier: ConventionIdentifier) -> DataStore {
        if self.conventionIdentifier == conventionIdentifier {
            return dataStore
        } else {
            return FakeDataStore()
        }
    }
    
}
