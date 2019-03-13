//
//  DefaultAnnouncementDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation.NSAttributedString

struct DefaultAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    private let announcementsService: AnnouncementsService
    private let markdownRenderer: MarkdownRenderer

    init() {
        self.init(announcementsService: SharedModel.instance.services.announcements,
                  markdownRenderer: DefaultDownMarkdownRenderer())
    }

    init(announcementsService: AnnouncementsService, markdownRenderer: MarkdownRenderer) {
        self.announcementsService = announcementsService
        self.markdownRenderer = markdownRenderer
    }

    func makeViewModel(for identifier: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        let service = announcementsService
        service.fetchAnnouncement(identifier: identifier) { (announcement) in
            service.fetchAnnouncementImage(identifier: identifier) { (imageData) in
                let contents = self.markdownRenderer.render(announcement.content)
                let viewModel = AnnouncementViewModel(heading: announcement.title, contents: contents, imagePNGData: imageData)
                completionHandler(viewModel)
            }
        }
    }

}
