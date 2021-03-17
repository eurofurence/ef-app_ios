import DealersComponent
import EurofurenceModel
import Foundation

final class StubDealerViewModel: DealerViewModel {

    var title: String = .random
    var subtitle: String? = .random
    var iconPNGData: Data = .random
    var isPresentForAllDays: Bool = .random
    var isAfterDarkContentPresent: Bool = .random

    func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {
        completionHandler(iconPNGData)
    }

}
