import EurofurenceModel
import EventDetailComponent
import TestUtilities

extension EventGraphicViewModel: RandomValueProviding {

    public static var random: EventGraphicViewModel {
        return EventGraphicViewModel(pngGraphicData: .random)
    }

}
