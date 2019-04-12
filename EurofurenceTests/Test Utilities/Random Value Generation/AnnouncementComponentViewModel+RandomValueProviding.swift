@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension AnnouncementComponentViewModel: RandomValueProviding {

    public static var random: AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: .random, detail: .random, receivedDateTime: .random, isRead: .random)
    }

}
