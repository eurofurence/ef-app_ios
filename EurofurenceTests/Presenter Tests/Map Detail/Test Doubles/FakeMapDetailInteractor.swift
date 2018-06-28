//
//  FakeMapDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeMapDetailInteractor: MapDetailInteractor {
    
    private let expectedMapIdentifier: Map2.Identifier
    
    init(expectedMapIdentifier: Map2.Identifier = .random) {
        self.expectedMapIdentifier = expectedMapIdentifier
    }
    
    let viewModel = FakeMapDetailViewModel()
    func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard identifier == expectedMapIdentifier else { return }
        completionHandler(viewModel)
    }
    
}

class FakeMapDetailViewModel: MapDetailViewModel {
    
    var mapImagePNGData: Data = .random
    var mapName: String = .random
    
    private(set) var positionToldToShowMapContentsFor: (x: Float, y: Float)?
    fileprivate var contentsVisitor: MapContentVisitor?
    func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor) {
        positionToldToShowMapContentsFor = (x: x, y: y)
        contentsVisitor = visitor
    }
    
}

extension FakeMapDetailViewModel {
    
    func resolvePositionalContent(with position: MapCoordinate) {
        contentsVisitor?.visit(position)
    }
    
    func resolvePositionalContent(with content: MapInformationContextualContent) {
        contentsVisitor?.visit(content)
    }
    
}
