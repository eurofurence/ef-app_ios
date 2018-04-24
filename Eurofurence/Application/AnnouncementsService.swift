//
//  AnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol AnnouncementsService {

    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void)

}
