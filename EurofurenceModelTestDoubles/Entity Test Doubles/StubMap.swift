//
//  Map+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

public struct StubMap: Map {

    public var identifier: MapIdentifier
    public var location: String
    
    public var imagePNGData: Data
    
    public func fetchImagePNGData(completionHandler: @escaping (Data) -> Void) {
        completionHandler(imagePNGData)
    }
    
    public func fetchContentAt(x: Int, y: Int, completionHandler: @escaping (MapContent) -> Void) {
        
    }

}

extension StubMap: RandomValueProviding {

    public static var random: StubMap {
        return StubMap(identifier: .random, location: .random, imagePNGData: .random)
    }

}
