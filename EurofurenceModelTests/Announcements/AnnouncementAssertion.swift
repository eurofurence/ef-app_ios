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

    private let file: StaticString
    private let line: UInt

    init(file: StaticString = #file,
         line: UInt = #line) {
        self.file = file
        self.line = line
    }

    private func assert<T>(_ first: T, isEqualTo second: T) where T: Equatable {
        XCTAssertEqual(first, second, file: file, line: line)
    }

    func assertOrderedAnnouncements(_ announcements: [Announcement],
                                    characterisedBy characteristics: [AnnouncementCharacteristics]) {
        guard announcements.count == characteristics.count else {
            XCTFail("Differing amount of expected/actual announcements", file: file, line: line)
            return
        }

        var orderedCharacteristics = orderAnnouncementsCharacteristicsByDate(characteristics)

        for (idx, announcement) in announcements.enumerated() {
            let characteristic = orderedCharacteristics[idx]

            assert(announcement.identifier, isEqualTo: AnnouncementIdentifier(characteristic.identifier))
            assert(announcement.title, isEqualTo: characteristic.title)
            assert(announcement.content, isEqualTo: characteristic.content)
            assert(announcement.date, isEqualTo: characteristic.lastChangedDateTime)
        }
    }

    private func orderAnnouncementsCharacteristicsByDate(_ characteristics: [AnnouncementCharacteristics]) -> [AnnouncementCharacteristics] {
        return characteristics.sorted { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
        }
    }

}
