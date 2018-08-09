//
//  ScheduleEventComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleEventComponent {

    func setEventName(_ title: String)
    func setEventStartTime(_ startTime: String)
    func setEventEndTime(_ endTime: String)
    func setLocation(_ location: String)
    func showFavouriteEventIndicator()
    func hideFavouriteEventIndicator()
    func showSponsorEventIndicator()
    func hideSponsorEventIndicator()
    func showSuperSponsorOnlyEventIndicator()
    func hideSuperSponsorOnlyEventIndicator()
    func showArtShowEventIndicator()
    func hideArtShowEventIndicator()
    func showKageEventIndicator()
    func hideKageEventIndicator()
    func showDealersDenEventIndicator()
    func hideDealersDenEventIndicator()
    func showMainStageEventIndicator()
    func hideMainStageEventIndicator()
    func showPhotoshootStageEventIndicator()
    func hidePhotoshootStageEventIndicator()

}
