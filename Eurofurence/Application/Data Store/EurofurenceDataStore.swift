//
//  EurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol EurofurenceDataStore {

    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void)
    func fetchKnowledgeGroups(completionHandler: ([KnowledgeGroup2]?) -> Void)

}

enum EurofurenceDataStoreContentsState {
    case empty
    case present
}
