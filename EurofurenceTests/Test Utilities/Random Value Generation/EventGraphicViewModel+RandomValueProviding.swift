@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension EventGraphicViewModel: RandomValueProviding {

    public static var random: EventGraphicViewModel {
        return EventGraphicViewModel(pngGraphicData: .random)
    }

}
