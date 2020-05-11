import Foundation

public struct DealersGroupViewModel {

    public var title: String
    public var dealers: [DealerViewModel]
    
    public init(title: String, dealers: [DealerViewModel]) {
        self.title = title
        self.dealers = dealers
    }

}

public protocol DealerViewModel {

    var title: String { get }
    var subtitle: String? { get }
    var isPresentForAllDays: Bool { get }
    var isAfterDarkContentPresent: Bool { get }

    func fetchIconPNGData(completionHandler: @escaping (Data) -> Void)

}
