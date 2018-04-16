//
//  AnnouncementsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSIndexPath

struct AnnouncementsViewModel: NewsViewModel {
    
    var announcements: [[AnnouncementComponentViewModel]]
    
    init() {
        announcements = (0...Int.random(upperLimit: 5) + 1).map { (index) -> [AnnouncementComponentViewModel] in
            return [AnnouncementComponentViewModel].random
        }
    }
    
    var numberOfComponents: Int {
        return announcements.count
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return announcements[index].count
    }
    
    func titleForComponent(at index: Int) -> String {
        return "Announcements"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        let announcement = announcements[indexPath.section][indexPath.row]
        visitor.visit(announcement)
    }
    
}
