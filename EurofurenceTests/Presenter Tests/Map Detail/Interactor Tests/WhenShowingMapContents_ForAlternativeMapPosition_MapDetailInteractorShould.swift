//
//  WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould: XCTestCase {

    func testConvertTheLocationIntoMapCoordinate() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let (expectedX, expectedY) = (Float.random, Float.random)
        randomMap.element.stub(content: .location(x: expectedX, y: expectedY, name: nil), atX: Int(x), y: Int(y))
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)

        let expected = MapCoordinate(x: expectedX, y: expectedY)
        XCTAssertEqual(expected, visitor.capturedMapCoordinate)
    }

    func testConvertTheLocationIntoContextualContentWithLocationName() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let (expectedX, expectedY) = (Float.random, Float.random)
        let expectedName = String.random
        let expectedMapCoordinate = MapCoordinate(x: expectedX, y: expectedY)
        randomMap.element.stub(content: .location(x: expectedX, y: expectedY, name: expectedName), atX: Int(x), y: Int(y))
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)

        let expected = MapInformationContextualContent(coordinate: expectedMapCoordinate, content: expectedName)
		XCTAssertEqual(expected, visitor.capturedContextualContent)
    }

    func testConvertTheRoomIntoContextualContentWithRoomName() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let room = Room.random
        randomMap.element.stub(content: .room(room), atX: Int(x), y: Int(y))
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)

        let expected = MapInformationContextualContent(coordinate: MapCoordinate(x: x, y: y), content: room.name)
        XCTAssertEqual(expected, visitor.capturedContextualContent)
    }

    func testProvideTheDealerForSelectedDealer() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        let expected = FakeDealer.random
        randomMap.element.stub(content: .dealer(expected), atX: Int(x), y: Int(y))
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)

        XCTAssertEqual(expected.identifier, visitor.capturedDealer)
    }

}
