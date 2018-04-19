//
//  NewsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath

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

struct AnnouncementComponentViewModel {

    var title: String
    var detail: String

}

struct EventComponentViewModel {

    var startTime: String
    var endTime: String

}
