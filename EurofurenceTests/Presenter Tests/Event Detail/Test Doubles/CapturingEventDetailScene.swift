//
//  CapturingEventDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class CapturingEventSummaryComponent: EventSummaryComponent {
    
    private(set) var capturedTitle: String?
    func setEventTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedSubtitle: NSAttributedString?
    func setEventSubtitle(_ subtitle: NSAttributedString) {
        capturedSubtitle = subtitle
    }
    
    private(set) var capturedEventStartTime: String?
    func setEventStartEndTime(_ startTime: String) {
        capturedEventStartTime = startTime
    }
    
    private(set) var capturedEventLocation: String?
    func setEventLocation(_ location: String) {
        capturedEventLocation = location
    }
    
    private(set) var capturedTrackName: String?
    func setTrackName(_ trackName: String) {
        capturedTrackName = trackName
    }
    
    private(set) var capturedEventHosts: String?
    func setEventHosts(_ eventHosts: String) {
        capturedEventHosts = eventHosts
    }
    
}

class CapturingEventDescriptionComponent: EventDescriptionComponent {
    
    private(set) var capturedEventDescription: NSAttributedString?
    func setEventDescription(_ eventDescription: NSAttributedString) {
        capturedEventDescription = eventDescription
    }
    
}

class CapturingEventGraphicComponent: EventGraphicComponent {
    
    private(set) var capturedPNGGraphicData: Data?
    func setPNGGraphicData(_ pngGraphicData: Data) {
        capturedPNGGraphicData = pngGraphicData
    }
    
}

class CapturingEventInformationBannerComponent: EventInformationBannerComponent {
    
    private(set) var capturedMessage: String?
    func setBannerMessage(_ message: String) {
        capturedMessage = message
    }
    
}

class StubEventDetailComponentFactory: EventDetailComponentFactory {
    
    let stubbedEventSummaryComponent = CapturingEventSummaryComponent()
    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> Any {
        block(stubbedEventSummaryComponent)
        return stubbedEventSummaryComponent
    }
    
    let stubbedEventDescriptionComponent = CapturingEventDescriptionComponent()
    func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> Any {
        block(stubbedEventDescriptionComponent)
        return stubbedEventDescriptionComponent
    }
    
    let stubbedEventGraphicComponent = CapturingEventGraphicComponent()
    func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> Any {
        block(stubbedEventGraphicComponent)
        return stubbedEventGraphicComponent
    }
    
    let stubbedSponsorsOnlyComponent = CapturingEventInformationBannerComponent()
    func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedSponsorsOnlyComponent)
        return stubbedSponsorsOnlyComponent
    }
    
    let stubbedSuperSponsorsOnlyComponent = CapturingEventInformationBannerComponent()
    func makeSuperSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedSuperSponsorsOnlyComponent)
        return stubbedSponsorsOnlyComponent
    }
    
}

class CapturingEventDetailScene: UIViewController, EventDetailScene {
    
    fileprivate var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    fileprivate let componentFactory = StubEventDetailComponentFactory()
    fileprivate var binder: EventDetailBinder?
    private(set) var numberOfBoundsComponents: Int?
    func bind(numberOfComponents: Int, using binder: EventDetailBinder) {
        numberOfBoundsComponents = numberOfComponents
        self.binder = binder
    }
    
    private(set) var didShowUnfavouriteEventButton = false
    func showUnfavouriteEventButton() {
        didShowUnfavouriteEventButton = true
    }
    
    private(set) var didShowFavouriteEventButton = false
    func showFavouriteEventButton() {
        didShowFavouriteEventButton = true
    }
    
}

extension CapturingEventDetailScene {
    
    var stubbedEventSummaryComponent: CapturingEventSummaryComponent {
        return componentFactory.stubbedEventSummaryComponent
    }
    
    var stubbedEventDescriptionComponent: CapturingEventDescriptionComponent {
        return componentFactory.stubbedEventDescriptionComponent
    }
    
    var stubbedEventGraphicComponent: CapturingEventGraphicComponent {
        return componentFactory.stubbedEventGraphicComponent
    }
    
    var stubbedSponsorsOnlyComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedSponsorsOnlyComponent
    }
    
    var stubbedSuperSponsorsOnlyComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedSuperSponsorsOnlyComponent
    }
    
    func simulateSceneDidLoad() {
        delegate?.eventDetailSceneDidLoad()
    }
    
    @discardableResult
    func bindComponent(at indexPath: IndexPath) -> Any? {
        return binder?.bindComponent(at: indexPath, using: componentFactory)
    }
    
    func simulateFavouriteEventButtonTapped() {
        delegate?.eventDetailSceneDidTapFavouriteEventButton()
    }
    
    func simulateUnfavouriteEventButtonTapped() {
        delegate?.eventDetailSceneDidTapUnfavouriteEventButton()
    }
    
}
