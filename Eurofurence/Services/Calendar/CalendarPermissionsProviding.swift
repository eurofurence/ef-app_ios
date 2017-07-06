//
//  CalendarPermissionsProviding.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CalendarPermissionsProviding {

    var isAuthorizedForEventsAccess: Bool { get }

    func requestAccessToEvents(completionHandler: @escaping (Bool) -> Void)

}
