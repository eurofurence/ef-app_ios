//
//  NewsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

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
    case announcement(Announcement2)

    static func ==(lhs: NewsViewModelValue, rhs: NewsViewModelValue) -> Bool {
        switch (lhs, rhs) {
        case (.messages, .messages):
            return true

        case (.announcement(let l), .announcement(let r)):
            return l == r

        default:
            return false
        }
    }
}

protocol NewsViewModelVisitor {

    func visit(_ userWidget: UserWidgetComponentViewModel)
    func visit(_ countdown: ConventionCountdownComponentViewModel)
    func visit(_ announcement: AnnouncementComponentViewModel)
    func visit(_ event: EventComponentViewModel)

}

struct ConventionCountdownComponentViewModel: Hashable {

    var timeUntilConvention: String

    var hashValue: Int {
        return timeUntilConvention.hashValue
    }

    static func ==(lhs: ConventionCountdownComponentViewModel, rhs: ConventionCountdownComponentViewModel) -> Bool {
        return lhs.timeUntilConvention == rhs.timeUntilConvention
    }

}

struct AnnouncementComponentViewModel: Hashable {

    var title: String
    var detail: String

    var hashValue: Int {
        return title.hashValue ^ detail.hashValue
    }

    static func ==(lhs: AnnouncementComponentViewModel, rhs: AnnouncementComponentViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.detail == rhs.detail
    }

}

struct EventComponentViewModel: Hashable {

    var startTime: String
    var endTime: String
    var eventName: String
    var location: String
    var icon: UIImage?

    var hashValue: Int {
        var iconHash = Int(arc4random())
        if let icon = icon {
            iconHash = icon.hashValue
        }

        return startTime.hashValue ^ endTime.hashValue ^ eventName.hashValue ^ location.hashValue ^ iconHash
    }

    static func ==(lhs: EventComponentViewModel, rhs: EventComponentViewModel) -> Bool {
        return lhs.startTime == rhs.startTime &&
               lhs.endTime == rhs.endTime &&
               lhs.eventName == rhs.eventName &&
               lhs.location == rhs.location &&
               lhs.icon == rhs.icon
    }

}

struct UserWidgetComponentViewModel: Hashable {

    var prompt: String
    var detailedPrompt: String
    var hasUnreadMessages: Bool

    var hashValue: Int {
        return prompt.hashValue ^ detailedPrompt.hashValue ^ hasUnreadMessages.hashValue
    }

    static func ==(lhs: UserWidgetComponentViewModel, rhs: UserWidgetComponentViewModel) -> Bool {
        return lhs.prompt == rhs.prompt && lhs.detailedPrompt == rhs.detailedPrompt && lhs.hasUnreadMessages == rhs.hasUnreadMessages
    }

}
