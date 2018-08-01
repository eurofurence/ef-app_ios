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
	private let markdownRenderer: MarkdownRenderer

    init() {
        self.init(announcementsService: EurofurenceApplication.shared,
                  announcementDateFormatter: FoundationAnnouncementDateFormatter.shared,
				  markdownRenderer: SubtleDownMarkdownRenderer())
    }

	init(announcementsService: AnnouncementsService, announcementDateFormatter: AnnouncementDateFormatter, markdownRenderer: MarkdownRenderer) {
        self.announcementsService = announcementsService
        self.announcementDateFormatter = announcementDateFormatter
		self.markdownRenderer = markdownRenderer
    }

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        let viewModel = ViewModel(
			announcementsService: announcementsService,
			announcementDateFormatter: announcementDateFormatter,
			markdownRenderer: markdownRenderer)
        completionHandler(viewModel)
    }

    private class ViewModel: AnnouncementsListViewModel, AnnouncementsServiceObserver {

        private let announcementDateFormatter: AnnouncementDateFormatter
		private let markdownRenderer: MarkdownRenderer
        private var announcements = [Announcement2]()
        private var readAnnouncements = [Announcement2.Identifier]()

        init(announcementsService: AnnouncementsService, announcementDateFormatter: AnnouncementDateFormatter,
			 markdownRenderer: MarkdownRenderer) {
            self.announcementDateFormatter = announcementDateFormatter
			self.markdownRenderer = markdownRenderer
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
			let detail = markdownRenderer.render(announcement.content)
			let receivedDateTime = announcementDateFormatter.string(from: announcement.date)

            return AnnouncementComponentViewModel(title: announcement.title,
                                                  detail: detail,
                                                  receivedDateTime: receivedDateTime,
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
