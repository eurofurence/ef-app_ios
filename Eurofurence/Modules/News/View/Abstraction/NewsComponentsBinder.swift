//
//  NewsComponentsBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath
import UIKit.UIImage

protocol NewsComponentsBinder {

    func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene)
    func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: NewsComponentFactory

}

protocol NewsComponentFactory {

    associatedtype Component

    func makeConventionCountdownComponent(configuringUsing block: (ConventionCountdownComponent) -> Void) -> Component
    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> Component
    func makeAnnouncementComponent(configuringUsing block: (NewsAnnouncementComponent) -> Void) -> Component
    func makeEventComponent(configuringUsing block: (NewsEventComponent) -> Void) -> Component

}

protocol ConventionCountdownComponent {

    func setTimeUntilConvention(_ timeUntilConvention: String)

}

protocol UserWidgetComponent {

    func setPrompt(_ prompt: String)
    func setDetailedPrompt(_ detailedPrompt: String)
    func showHighlightedUserPrompt()
    func hideHighlightedUserPrompt()
    func showStandardUserPrompt()
    func hideStandardUserPrompt()

}

protocol NewsAnnouncementComponent {

    func setAnnouncementTitle(_ title: String)
    func setAnnouncementDetail(_ detail: String)

}

protocol NewsEventComponent {

    func setEventStartTime(_ startTime: String)
    func setEventEndTime(_ endTime: String)
    func setEventName(_ eventName: String)
    func setLocation(_ location: String)
    func setIcon(_ icon: UIImage?)

}
