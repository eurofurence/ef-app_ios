//
//  NewsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation.NSIndexPath
import UIKit.UIImage

protocol NewsViewModel {

    var numberOfComponents: Int { get }

    func numberOfItemsInComponent(at index: Int) -> Int
    func titleForComponent(at index: Int) -> String
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor)
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void)

}

enum NewsViewModelValue: Equatable {
    case messages
    case announcement(Announcement2.Identifier)
    case allAnnouncements
    case event(Event2)

    static func ==(lhs: NewsViewModelValue, rhs: NewsViewModelValue) -> Bool {
        switch (lhs, rhs) {
        case (.messages, .messages):
            return true

        case (.announcement(let l), .announcement(let r)):
            return l == r

        case (.event(let l), .event(let r)):
            return l == r

        case (.allAnnouncements, .allAnnouncements):
            return true

        default:
            return false
        }
    }
}

protocol NewsViewModelVisitor {

    func visit(_ userWidget: UserWidgetComponentViewModel)
    func visit(_ countdown: ConventionCountdownComponentViewModel)
    func visit(_ announcement: AnnouncementComponentViewModel)
    func visit(_ viewAllAnnouncements: ViewAllAnnouncementsComponentViewModel)
    func visit(_ event: EventComponentViewModel)

}

struct ConventionCountdownComponentViewModel: Hashable {

    var timeUntilConvention: String

}

struct AnnouncementComponentViewModel: Hashable {

    var title: String
    var detail: NSAttributedString
    var receivedDateTime: String
    var isRead: Bool

}

struct ViewAllAnnouncementsComponentViewModel: Hashable {

    var caption: String

}

struct EventComponentViewModel: Hashable {

    var startTime: String
    var endTime: String
    var eventName: String
    var location: String
    var isSponsorEvent: Bool
    var isSuperSponsorEvent: Bool
    var isFavourite: Bool
    var isArtShowEvent: Bool
    var isKageEvent: Bool
    var isDealersDenEvent: Bool
    var isMainStageEvent: Bool
    var isPhotoshootEvent: Bool

}

struct UserWidgetComponentViewModel: Hashable {

    var prompt: String
    var detailedPrompt: String
    var hasUnreadMessages: Bool

}
