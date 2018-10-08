//
//  FakeMapsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeMapsService: MapsService {
    
    let maps = [Map2].random
    func add(_ observer: MapsObserver) {
        observer.mapsServiceDidChangeMaps(maps)
    }
    
    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        completionHandler(imagePNGDataForMap(identifier: identifier))
    }
    
    struct ContentRequest: Equatable {
        static func == (lhs: FakeMapsService.ContentRequest, rhs: FakeMapsService.ContentRequest) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var identifier: Map2.Identifier
        var x: Int
        var y: Int
        var completionHandler: (Map2.Content) -> Void
    }
    
    fileprivate var requests = [ContentRequest]()
    func fetchContent(for identifier: Map2.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map2.Content) -> Void) {
        requests.append(ContentRequest(identifier: identifier, x: x, y: y, completionHandler: completionHandler))
    }
    
}

extension FakeMapsService {
    
    func imagePNGDataForMap(identifier: Map2.Identifier) -> Data {
        return identifier.rawValue.data(using: .utf8)!
    }
    
    func resolveMapContents(identifier: Map2.Identifier, atX x: Int, y: Int, with mapContent: Map2.Content) {
        guard let request = requests.first(where: { $0.identifier == identifier && $0.x == x && $0.y == y }) else { return }
        request.completionHandler(mapContent)
    }
    
}
