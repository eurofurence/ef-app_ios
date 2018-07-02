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
    
    init(announcementsService: AnnouncementsService) {
        self.announcementsService = announcementsService
    }
    
    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        let viewModel = ViewModel(announcementsService: announcementsService)
        completionHandler(viewModel)
    }
    
    private class ViewModel: AnnouncementsListViewModel, AnnouncementsServiceObserver {
        
        private var announcements = [Announcement2]()
        
        init(announcementsService: AnnouncementsService) {
            announcementsService.add(self)
        }
        
        var numberOfAnnouncements: Int {
            return announcements.count
        }
        
        func setDelegate(_ delegate: AnnouncementsListViewModelDelegate) {
            
        }
        
        func announcementViewModel(at index: Int) -> AnnouncementComponentViewModel {
            fatalError("Not implemented")
        }
        
        func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2]) {
            self.announcements = announcements
        }
        
        func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [Announcement2.Identifier]) {
            
        }
        
    }
    
}
