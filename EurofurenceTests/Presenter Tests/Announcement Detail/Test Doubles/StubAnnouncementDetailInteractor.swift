//
//  StubAnnouncementDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubAnnouncementDetailInteractor: AnnouncementDetailInteractor {
    
    var viewModel: AnnouncementViewModel = .random
    func makeViewModel(completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
