//
//  ScheduleSceneSearchResultsBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleSceneSearchResultsBinder {

    func bind(_ eventComponent: ScheduleEventComponent, forSearchResultAt indexPath: IndexPath)
    func bind(_ header: ScheduleEventGroupHeader, forSearchResultGroupAt index: Int)

}
