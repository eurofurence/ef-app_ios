//
//  CapturingMapCoordinateRender.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingMapCoordinateRender: MapCoordinateRender {
    
    private struct Request: Hashable {
        var graphic: Data
        var x: Int
        var y: Int
        var radius: Int
    }
    
    private var requestsToResponses = [Request : Data]()
    func render(x: Int, y: Int, radius: Int, onto data: Data) -> Data {
        let request = Request(graphic: data, x: x, y: y, radius: radius)
        return requestsToResponses[request] ?? .random
    }
    
}

extension CapturingMapCoordinateRender {
    
    func stub(_ data: Data, forGraphic graphic: Data, atX x: Int, y: Int, radius: Int) {
        let request = Request(graphic: graphic, x: x, y: y, radius: radius)
        requestsToResponses[request] = data
    }
    
}
