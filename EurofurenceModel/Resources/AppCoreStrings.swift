//
//  AppCoreStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public class AppCoreStrings {

    private static var bundle: Bundle {
        return Bundle(for: AppCoreStrings.self)
    }

    private static let eventReminderBodyFormat = NSLocalizedString("EventReminderBodyFormat",
                                                                   tableName: "AppCoreStrings",
                                                                   bundle: AppCoreStrings.bundle,
                                                                   comment: "Format string used for event reminder notifications to tell the user when and where an upcoming event is taking place")

    public static func eventReminderBody(timeString: String, roomName: String) -> String {
        return String.localizedStringWithFormat(eventReminderBodyFormat, timeString, roomName)
    }

}
