//
//  V2SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct V2SyncAPI: SyncAPI {

    var jsonSession: JSONSession
    private let decoder = JSONDecoder()

    func fetchLatestData(completionHandler: @escaping (APISyncResponse?) -> Void) {
        let url = "https://app.eurofurence.org/api/v2/Sync"
        let request = JSONRequest(url: url, body: Data())
        jsonSession.get(request) { (data, _) in
            var response: APISyncResponse?
            defer { completionHandler(response) }

            if let data = data {
                response = (try? self.decoder.decode(JSONSyncResponse.self, from: data))?.asAPIResponse()
            }
        }
    }

}

private struct JSONSyncResponse: Decodable {

    func asAPIResponse() -> APISyncResponse {
        return APISyncResponse(knowledgeGroups: KnowledgeGroups.asDelta(),
                               knowledgeEntries: KnowledgeEntries.asDelta())
    }

    struct Leaf<T>: Decodable where T: Decodable & ModelRepresenting {
        var ChangedEntities: [T]
        var DeletedEntities: [T]

        func asDelta() -> APISyncDelta<T.ModelType> {
            return APISyncDelta(changed: ChangedEntities.map({ $0.asModel() }),
                                deleted: DeletedEntities.map({ $0.asModel() }))
        }
    }

    struct JSONKnowledgeGroup: Decodable, ModelRepresenting {
        var Id: String
        var Order: Int
        var Name: String
        var Description: String

        func asModel() -> APIKnowledgeGroup {
            return APIKnowledgeGroup(identifier: Id, order: Order, groupName: Name, groupDescription: Description)
        }
    }

    struct JSONKnowledgeEntry: Decodable, ModelRepresenting {
        var KnowledgeGroupId: String
        var Title: String
        var Order: Int

        func asModel() -> APIKnowledgeEntry {
            return APIKnowledgeEntry(groupIdentifier: KnowledgeGroupId, title: Title, order: Order)
        }
    }

    var KnowledgeGroups: Leaf<JSONKnowledgeGroup>
    var KnowledgeEntries: Leaf<JSONKnowledgeEntry>

}

private protocol ModelRepresenting {
    associatedtype ModelType: Equatable

    func asModel() -> ModelType
}
