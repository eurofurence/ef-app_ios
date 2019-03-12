//
//  StubDataStoreFactory.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

struct StubDataStoreFactory: DataStoreFactory {
    
    var dataStore: DataStore
    
    func makeDataStore() -> DataStore {
        return dataStore
    }
    
}
