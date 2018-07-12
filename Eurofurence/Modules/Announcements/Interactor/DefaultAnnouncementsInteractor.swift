//
//  DefaultAnnouncementsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultAnnouncementsInteractor: AnnouncementsInteractor {

    private let announcementsService: AnnouncementsService
    private let announcementDateFormatter: AnnouncementDateFormatter

    init() {
        self.init(announcementsService: EurofurenceApplication.shared,
                  announcementDateFormatter: FoundationAnnouncementDateFormatter.shared)
    }

    init(announcementsService: AnnouncementsService, announcementDateFormatter: AnnouncementDateFormatter) {
        self.announcementsService = announcementsService
        self.announcementDateFormatter = announcementDateFormatter
    }

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        let viewModel = ViewModel(announcementsService: announcementsService, announcementDateFormatter: announcementDateFormatter)
        completionHandler(viewModel)
    }

    private class ViewModel: AnnouncementsListViewModel, AnnouncementsServiceObserver {

        private let announcementDateFormatter: AnnouncementDateFormatter
        private var announcements = [Announcement2]()
        private var readAnnouncements = [Announcement2.Identifier]()

        init(announcementsService: AnnouncementsService, announcementDateFormatter: AnnouncementDateFormatter) {
            self.announcementDateFormatter = announcementDateFormatter
            announcementsService.add(self)
        }

        var numberOfAnnouncements: Int {
            return announcements.count
        }

        private var delegate: AnnouncementsListViewModelDelegate?
        func setDelegate(_ delegate: AnnouncementsListViewModelDelegate) {
            self.delegate = delegate
        }

        func announcementViewModel(at index: Int) -> AnnouncementComponentViewModel {
            let announcement = announcements[index]
            let isRead = readAnnouncements.contains(announcement.identifier)

            return AnnouncementComponentViewModel(title: announcement.title,
                                                  detail: announcement.content,
                                                  receivedDateTime: announcementDateFormatter.string(from: announcement.date),
                                                  isRead: isRead)
        }

        func identifierForAnnouncement(at index: Int) -> Announcement2.Identifier {
            return announcements[index].identifier
        }

        func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2]) {
            self.announcements = announcements
            delegate?.announcementsViewModelDidChangeAnnouncements()
        }

        func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [Announcement2.Identifier]) {
            self.readAnnouncements = readAnnouncements
            delegate?.announcementsViewModelDidChangeAnnouncements()
        }

    }

}
