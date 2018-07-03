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
    
}
