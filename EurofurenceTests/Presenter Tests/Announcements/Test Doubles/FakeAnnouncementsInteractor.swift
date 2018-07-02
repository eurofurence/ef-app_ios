//
//  FakeAnnouncementsInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct FakeAnnouncementsInteractor: AnnouncementsInteractor {
    
    private let viewModel: AnnouncementsListViewModel
    
    init(viewModel: AnnouncementsListViewModel = FakeAnnouncementsListViewModel()) {
        self.viewModel = viewModel
    }
    
    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
