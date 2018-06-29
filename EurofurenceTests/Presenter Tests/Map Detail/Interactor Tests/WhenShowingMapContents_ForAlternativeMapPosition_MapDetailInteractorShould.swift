//
//  WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould: XCTestCase {
    
    func testConvertTheLocationIntoMapCoordinate() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        
        let (x, y) = (Float.random, Float.random)
        let (expectedX, expectedY) = (Float.random, Float.random)
        let expected = MapCoordinate(x: expectedX, y: expectedY)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .location(x: expectedX, y: expectedY))
        
        XCTAssertEqual(expected, visitor.capturedMapCoordinate)
    }
    
    func testConvertTheRoomIntoContextualContentWithRoomName() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        
        let (x, y) = (Float.random, Float.random)
        let room = Room.random
        let expected = MapInformationContextualContent(coordinate: MapCoordinate(x: x, y: y), content: room.name)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .room(room))
        
        XCTAssertEqual(expected, visitor.capturedContextualContent)
    }
    
    func testProvideTheDealerIdentifierForSelectedDealer() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        
        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let expected = Dealer2.Identifier.random
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .dealer(expected))
        
        XCTAssertEqual(expected, visitor.capturedDealer)
    }
    
}
