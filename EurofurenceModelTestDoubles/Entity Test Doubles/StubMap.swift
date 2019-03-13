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

public final class StubMap: Map {

    public var identifier: MapIdentifier
    public var location: String
    
    public var imagePNGData: Data
    public var mapContent: MapContent?

    public init(identifier: MapIdentifier, location: String, imagePNGData: Data) {
        self.identifier = identifier
        self.location = location
        self.imagePNGData = imagePNGData
    }
    
    public func fetchImagePNGData(completionHandler: @escaping (Data) -> Void) {
        completionHandler(imagePNGData)
    }
    
    public func fetchContentAt(x: Int, y: Int, completionHandler: @escaping (MapContent) -> Void) {
        if let mapContent = stubbedContent.first(where: { $0.x == x && $0.y == y }) {
            completionHandler(mapContent.content)
        }
    }
    
    private struct StubbedContent: Equatable {
        static func == (lhs: StubbedContent, rhs: StubbedContent) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var content: MapContent
        var x: Int
        var y: Int
    }
    
    private var stubbedContent = [StubbedContent]()
    public func stub(content: MapContent, atX x: Int, y: Int) {
        stubbedContent.append(StubbedContent(content: content, x: x, y: y))
    }

}

extension StubMap: RandomValueProviding {

    public static var random: StubMap {
        return StubMap(identifier: .random, location: .random, imagePNGData: .random)
    }

}
