//
//  AnnouncementsListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol AnnouncementsListViewModel {

    var numberOfAnnouncements: Int { get }

    func setDelegate(_ delegate: AnnouncementsListViewModelDelegate)
    func announcementViewModel(at index: Int) -> AnnouncementComponentViewModel
    func identifierForAnnouncement(at index: Int) -> Announcement2.Identifier

}

protocol AnnouncementsListViewModelDelegate {

    func announcementsViewModelDidChangeAnnouncements()

}
