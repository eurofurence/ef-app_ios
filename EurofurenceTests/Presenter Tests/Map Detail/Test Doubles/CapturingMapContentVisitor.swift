//
//  CapturingMapContentVisitor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingMapContentVisitor: MapContentVisitor {
    
    private(set) var capturedMapCoordinate: MapCoordinate?
    func visit(_ mapPosition: MapCoordinate) {
        capturedMapCoordinate = mapPosition
    }
    
    func visit(_ content: MapInformationContextualContent) {
        
    }
    
}
