//
//  DataStoreFactory.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol DataStoreFactory {
    
    func makeDataStore() -> DataStore
    
}
