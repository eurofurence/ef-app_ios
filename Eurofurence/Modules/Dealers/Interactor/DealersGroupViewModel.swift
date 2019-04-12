import Foundation

struct DealersGroupViewModel {

    var title: String
    var dealers: [DealerViewModel]

}

protocol DealerViewModel {

    var title: String { get }
    var subtitle: String? { get }
    var isPresentForAllDays: Bool { get }
    var isAfterDarkContentPresent: Bool { get }

    func fetchIconPNGData(completionHandler: @escaping (Data) -> Void)

}
