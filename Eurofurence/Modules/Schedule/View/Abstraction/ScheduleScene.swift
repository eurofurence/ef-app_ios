//
//  ScheduleScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol ScheduleScene {

    func setDelegate(_ delegate: ScheduleSceneDelegate)
    func setScheduleTitle(_ title: String)
    func bind(numberOfDays: Int)
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)

}

protocol ScheduleSceneDelegate {

    func scheduleSceneDidLoad()

}
