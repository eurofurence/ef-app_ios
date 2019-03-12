//
//  CoreDataStoreFactory.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public struct CoreDataStoreFactory: DataStoreFactory {
    
    public func makeDataStore(for conventionIdentifier: ConventionIdentifier) -> DataStore {
        return CoreDataStore(storeName: conventionIdentifier.identifier)
    }
    
}
