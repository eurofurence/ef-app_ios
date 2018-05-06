//
//  DefaultAnnouncementDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSAttributedString

struct DefaultAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    var announcement: Announcement2
    var markdownRenderer: MarkdownRenderer

    func makeViewModel(completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        let contents = markdownRenderer.render(announcement.content)
        let viewModel = AnnouncementViewModel(heading: announcement.title, contents: contents)
        completionHandler(viewModel)
    }

}
