//
//  AnnouncementAssertion.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

struct AnnouncementAssertion {

    static func assertOrderedAnnouncements(_ announcements: [Announcement],
                                           characterisedBy characteristics: [AnnouncementCharacteristics],
                                           file: StaticString = #file,
                                           line: UInt = #line) {
        guard announcements.count == characteristics.count else {
            XCTFail("Differing amount of expected/actual announcements", file: file, line: line)
            return
        }

        var orderedCharacteristics = orderAnnouncementsCharacteristicsByDate(characteristics)

        for (idx, announcement) in announcements.enumerated() {
            let characteristic = orderedCharacteristics[idx]

            XCTAssertEqual(announcement.identifier, AnnouncementIdentifier(characteristic.identifier), file: file, line: line)
            XCTAssertEqual(announcement.title, characteristic.title, file: file, line: line)
            XCTAssertEqual(announcement.content, characteristic.content, file: file, line: line)
            XCTAssertEqual(announcement.date, characteristic.lastChangedDateTime, file: file, line: line)
        }
    }

    private static func orderAnnouncementsCharacteristicsByDate(_ characteristics: [AnnouncementCharacteristics]) -> [AnnouncementCharacteristics] {
        return characteristics.sorted { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
        }
    }

}
