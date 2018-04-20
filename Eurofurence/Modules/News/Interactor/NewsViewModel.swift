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

}

protocol NewsViewModelVisitor {

    func visit(_ announcement: AnnouncementComponentViewModel)
    func visit(_ event: EventComponentViewModel)

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
