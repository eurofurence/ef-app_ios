//
//  CoreDataStoreFactory.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public struct CoreDataStoreFactory: DataStoreFactory {
    
    public func makeDataStore() -> DataStore {
        return CoreDataStore(storeName: "EF24")
    }
    
}
