import Foundation

extension ReadAnnouncementEntity: EntityAdapting {

    typealias AdaptedType = AnnouncementIdentifier

    static func makeIdentifyingPredicate(for model: AnnouncementIdentifier) -> NSPredicate {
        return NSPredicate(format: "announcementIdentifier == %@", model.rawValue)
    }

    func asAdaptedType() -> AnnouncementIdentifier {
        return AnnouncementIdentifier(announcementIdentifier!)
    }

    func consumeAttributes(from value: AnnouncementIdentifier) {
        announcementIdentifier = value.rawValue
    }

}
