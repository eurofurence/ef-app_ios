import EurofurenceApplication
import EurofurenceModel
import TestUtilities

extension EventDescriptionViewModel: RandomValueProviding {

    public static var random: EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: .random)
    }

}
