//
//  EventDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol EventDetailScene {

    func setDelegate(_ delegate: EventDetailSceneDelegate)
    func bind(using binder: EventDetailBinder)

}

protocol EventDetailSceneDelegate {

    func eventDetailSceneDidLoad()

}
