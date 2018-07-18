//
//  ScheduleSceneBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleSceneBinder {

    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int)
    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath)
    func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction

}

struct ScheduleEventComponentAction {
    var title: String
    var run: () -> Void
}
