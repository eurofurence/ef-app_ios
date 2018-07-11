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
    
    private(set) var capturedMapData: Data?
    private(set) var x: Int?
    private(set) var y: Int?
    private(set) var radius: Int?
    func render(x: Int, y: Int, radius: Int, onto data: Data) {
        capturedMapData = data
        self.x = x
        self.y = y
        self.radius = radius
    }
    
}
