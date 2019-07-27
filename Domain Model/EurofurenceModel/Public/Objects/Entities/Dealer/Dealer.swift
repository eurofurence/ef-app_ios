import Foundation

public typealias DealerIdentifier = Identifier<Dealer>

public protocol Dealer {

    var identifier: DealerIdentifier { get }

    var preferredName: String { get }
    var alternateName: String? { get }

    var isAttendingOnThursday: Bool { get }
    var isAttendingOnFriday: Bool { get }
    var isAttendingOnSaturday: Bool { get }

    var isAfterDark: Bool { get }
    
    func openWebsite()
    func openTwitter()
    func openTelegram()
    
    func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void)
    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void)
    
    func makeContentURL() -> URL

}
