//
//  StubAnnouncementDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation

struct StubAnnouncementDetailInteractor: AnnouncementDetailInteractor {
    
    let viewModel: AnnouncementViewModel
    private var identifier: Announcement2.Identifier
    
    init(viewModel: AnnouncementViewModel = .random, for identifier: Announcement2.Identifier = .random) {
        self.viewModel = viewModel
        self.identifier = identifier
    }
    
    func makeViewModel(for announcement: Announcement2.Identifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        guard identifier == announcement else { return }
        completionHandler(viewModel)
    }
    
}
