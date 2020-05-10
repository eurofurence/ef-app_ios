@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension AnnouncementItemViewModel: RandomValueProviding {

    public static var random: AnnouncementItemViewModel {
        return AnnouncementItemViewModel(title: .random, detail: .random, receivedDateTime: .random, isRead: .random)
    }

}
