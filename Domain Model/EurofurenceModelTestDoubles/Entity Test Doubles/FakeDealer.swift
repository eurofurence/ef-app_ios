import EurofurenceModel
import TestUtilities

public final class FakeDealer: Dealer {

    public var identifier: DealerIdentifier
    public var preferredName: String
    public var alternateName: String?
    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool
    public var isAfterDark: Bool
    
    public var extendedData: ExtendedDealerData?
    public var iconPNGData: Data?

    public init(identifier: DealerIdentifier,
                preferredName: String,
                alternateName: String?,
                isAttendingOnThursday: Bool,
                isAttendingOnFriday: Bool,
                isAttendingOnSaturday: Bool,
                isAfterDark: Bool) {
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }
    
    public private(set) var websiteOpened = false
    public func openWebsite() {
        websiteOpened = true
    }
    
    public private(set) var twitterOpened = false
    public func openTwitter() {
        twitterOpened = true
    }
    
    public private(set) var telegramOpened = false
    public func openTelegram() {
        telegramOpened = true
    }
    
    public func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void) {
        extendedData.let(completionHandler)
    }
    
    public func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconPNGData)
    }
    
    public let shareableURL = URL.random
    public var contentURL: URL {
        return shareableURL
    }

}

extension FakeDealer: RandomValueProviding {

    public static var random: FakeDealer {
        return FakeDealer(identifier: .random,
                          preferredName: .random,
                          alternateName: .random,
                          isAttendingOnThursday: .random,
                          isAttendingOnFriday: .random,
                          isAttendingOnSaturday: .random,
                          isAfterDark: .random)
    }

}
