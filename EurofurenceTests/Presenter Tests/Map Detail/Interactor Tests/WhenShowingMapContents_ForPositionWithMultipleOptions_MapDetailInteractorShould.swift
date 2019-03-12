//
//  WhenShowingMapContents_ForPositionWithMultipleOptions_MapDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenShowingMapContents_ForPositionWithMultipleOptions_MapDetailInteractorShould: XCTestCase {

    func testEmitViewModelWithExpectedOptionNames() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let dealer = FakeDealer.random
        let room = Room.random
        let content: MapContent = .multiple([.dealer(dealer), .room(room)])
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: content)
        let expectedOptions = [dealer.preferredName, room.name]

        XCTAssertEqual(expectedOptions, visitor.capturedMapContents?.options)
    }

    func testEmitViewModelWithExpectedTitle() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let dealer = FakeDealer.random
        let room = Room.random
        let content: MapContent = .multiple([.dealer(dealer), .room(room)])
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: content)

        XCTAssertEqual(.selectAnOption, visitor.capturedMapContents?.optionsHeading)
    }

    func testEmitExpectedModelWhenSelectingOption() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let (x, y) = (Float.random, Float.random)
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let dealer = FakeDealer.random
        let room = Room.random
        let contents: [MapContent] = [.dealer(dealer), .room(room)]
        let content: MapContent = .multiple(contents)
        mapsService.resolveMapContents(identifier: randomMap.element.identifier, atX: Int(x), y: Int(y), with: content)
        visitor.capturedMapContents?.selectOption(at: 0)

        XCTAssertEqual(dealer.identifier, visitor.capturedDealer)
    }

}
