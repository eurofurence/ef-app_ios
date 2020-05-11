import Eurofurence
import EurofurenceModel
import TestUtilities

extension AnnouncementDetailViewModel: RandomValueProviding {

    public static var random: AnnouncementDetailViewModel {
        return AnnouncementDetailViewModel(heading: .random, contents: .random, imagePNGData: .random)
    }

}
