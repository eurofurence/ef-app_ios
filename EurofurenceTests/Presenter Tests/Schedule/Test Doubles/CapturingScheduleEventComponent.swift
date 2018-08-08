//
//  CapturingScheduleEventComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleEventComponent: ScheduleEventComponent {
    
    private(set) var capturedEventTitle: String?
    func setEventName(_ title: String) {
        capturedEventTitle = title
    }
    
    private(set) var capturedStartTime: String?
    func setEventStartTime(_ startTime: String) {
        capturedStartTime = startTime
    }
    
    private(set) var capturedEndTime: String?
    func setEventEndTime(_ endTime: String) {
        capturedEndTime = endTime
    }
    
    private(set) var capturedLocation: String?
    func setLocation(_ location: String) {
        capturedLocation = location
    }
    
    private(set) var didShowFavouriteEventIndicator = false
    func showFavouriteEventIndicator() {
        didShowFavouriteEventIndicator = true
    }
    
    private(set) var didHideFavouriteEventIndicator = false
    func hideFavouriteEventIndicator() {
        didHideFavouriteEventIndicator = true
    }
    
    private(set) var didShowSponsorEventIndicator = false
    func showSponsorEventIndicator() {
        didShowSponsorEventIndicator = true
    }
    
    private(set) var didHideSponsorEventIndicator = false
    func hideSponsorEventIndicator() {
        didHideSponsorEventIndicator = true
    }
    
    private(set) var didShowSuperSponsorOnlyEventIndicator = false
    func showSuperSponsorOnlyEventIndicator() {
        didShowSuperSponsorOnlyEventIndicator = true
    }
    
    private(set) var didHideSuperSponsorOnlyEventIndicator = false
    func hideSuperSponsorOnlyEventIndicator() {
        didHideSuperSponsorOnlyEventIndicator = true
    }
    
    private(set) var didShowArtShowEventIndicator = false
    func showArtShowEventIndicator() {
        didShowArtShowEventIndicator = true
    }
    
    private(set) var didHideArtShowEventIndicator = false
    func hideArtShowEventIndicator() {
        didHideArtShowEventIndicator = true
    }
    
    private(set) var didShowKageEventIndicator = false
    func showKageEventIndicator() {
        didShowKageEventIndicator = true
    }
    
    private(set) var didHideKageEventIndicator = false
    func hideKageEventIndicator() {
        didHideKageEventIndicator = true
    }
    
}
