import Eurofurence
import EurofurenceModel
import TestUtilities

extension ConventionCountdownComponentViewModel: RandomValueProviding {

    public static var random: ConventionCountdownComponentViewModel {
        return ConventionCountdownComponentViewModel(timeUntilConvention: .random)
    }

}
