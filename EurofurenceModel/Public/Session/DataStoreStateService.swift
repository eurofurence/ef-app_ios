//
//  DataStoreStateService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 03/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol DataStoreStateService {
    
    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void)
    
}
