import EurofurenceModel
import Foundation
import TestUtilities

public final class StubAnnouncement: Announcement {
    
    public enum ReadStatus: Equatable {
        case unread
        case read
    }

    public var identifier: AnnouncementIdentifier
    public var title: String
    public var content: String
    public var date: Date
    
    public var imagePNGData: Data?
    
    public private(set) var readStatus: ReadStatus = .unread

    public init(
        identifier: AnnouncementIdentifier,
        title: String,
        content: String,
        date: Date
    ) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }
    
    public func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void) {
        completionHandler(imagePNGData)
    }
    
    public func markRead() {
        readStatus = .read
    }

}

extension StubAnnouncement: RandomValueProviding {

    public static var random: StubAnnouncement {
        return StubAnnouncement(
            identifier: .random,
            title: .random,
            content: .random,
            date: .random
        )
    }
    
}
