//
//  WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FakeAnnouncementsListViewModel: AnnouncementsListViewModel {
    
    let announcements = [Announcement2].random
    
    var numberOfAnnouncements: Int {
        return announcements.count
    }
    
}

struct FakeAnnouncementsInteractor: AnnouncementsInteractor {
    
    private let viewModel: AnnouncementsListViewModel
    
    init(viewModel: AnnouncementsListViewModel = FakeAnnouncementsListViewModel()) {
        self.viewModel = viewModel
    }
    
    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}

class WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould: XCTestCase {
    
    func testBindTheNumberOfAnnouncementsFromTheViewModelOntoTheScene() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(viewModel.announcements.count, context.scene.capturedAnnouncementsToBind)
    }
    
}
