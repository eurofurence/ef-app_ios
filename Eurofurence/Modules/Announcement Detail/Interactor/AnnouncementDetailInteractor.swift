//
//  AnnouncementDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol AnnouncementDetailInteractor {

    func makeViewModel(completionHandler: @escaping (AnnouncementViewModel) -> Void)

}
