@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension AnnouncementViewModel: RandomValueProviding {

    public static var random: AnnouncementViewModel {
        return AnnouncementViewModel(heading: .random, contents: .random, imagePNGData: .random)
    }

}
