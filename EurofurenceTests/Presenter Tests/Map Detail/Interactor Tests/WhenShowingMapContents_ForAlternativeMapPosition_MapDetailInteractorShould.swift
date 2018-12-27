//
//  WhenShowingMapContents_ForAlternativeMapPosition_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
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
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .location(x: expectedX, y: expectedY, name: nil))

        XCTAssertEqual(expected, visitor.capturedMapCoordinate)
    }

    func testConvertTheLocationIntoContextualContentWithLocationName() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let (x, y) = (Float.random, Float.random)
        let (expectedX, expectedY) = (Float.random, Float.random)
		let expectedName = String.random
        let expectedMapCoordinate = MapCoordinate(x: expectedX, y: expectedY)
		let expected = MapInformationContextualContent(coordinate: expectedMapCoordinate, content: expectedName)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .location(x: expectedX, y: expectedY, name: expectedName))

		XCTAssertEqual(expected, visitor.capturedContextualContent)
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

    func testProvideTheDealerForSelectedDealer() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let expected = Dealer.random
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: .dealer(expected))

        XCTAssertEqual(expected.identifier, visitor.capturedDealer)
    }

}
