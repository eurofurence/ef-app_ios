//
//  StubAnnouncementDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import Foundation

struct StubAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    let viewModel: AnnouncementViewModel
    private var identifier: Announcement.Identifier

    init(viewModel: AnnouncementViewModel = .random, for identifier: Announcement.Identifier = .random) {
        self.viewModel = viewModel
        self.identifier = identifier
    }

    func makeViewModel(for announcement: Announcement.Identifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        guard identifier == announcement else { return }
        completionHandler(viewModel)
    }

}
