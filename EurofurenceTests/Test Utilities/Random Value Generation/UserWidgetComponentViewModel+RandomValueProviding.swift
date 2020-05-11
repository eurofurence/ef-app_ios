import Eurofurence
import EurofurenceModel
import TestUtilities

extension UserWidgetComponentViewModel: RandomValueProviding {

    public static var random: UserWidgetComponentViewModel {
        return UserWidgetComponentViewModel(prompt: .random, detailedPrompt: .random, hasUnreadMessages: .random)
    }

}
