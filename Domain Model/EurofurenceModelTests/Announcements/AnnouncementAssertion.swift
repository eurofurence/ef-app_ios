import EurofurenceModel
import TestUtilities

class AnnouncementAssertion: Assertion {

    func assertOrderedAnnouncements(_ announcements: [Announcement],
                                    characterisedBy characteristics: [AnnouncementCharacteristics]) {
        guard announcements.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual announcements")
            return
        }

        let orderedCharacteristics = orderAnnouncementsCharacteristicsByDate(characteristics)

        for (idx, announcement) in announcements.enumerated() {
            let characteristic = orderedCharacteristics[idx]
            assertAnnouncement(announcement, characterisedBy: characteristic)
        }
    }

    func assertAnnouncement(_ announcement: Announcement?,
                            characterisedBy characteristic: AnnouncementCharacteristics) {
        assert(announcement?.identifier, isEqualTo: AnnouncementIdentifier(characteristic.identifier))
        assert(announcement?.title, isEqualTo: characteristic.title)
        assert(announcement?.content, isEqualTo: characteristic.content)
        assert(announcement?.date, isEqualTo: characteristic.lastChangedDateTime)
    }

    private func orderAnnouncementsCharacteristicsByDate(
        _ characteristics: [AnnouncementCharacteristics]
    ) -> [AnnouncementCharacteristics] {
        return characteristics.sorted { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
        }
    }

}
