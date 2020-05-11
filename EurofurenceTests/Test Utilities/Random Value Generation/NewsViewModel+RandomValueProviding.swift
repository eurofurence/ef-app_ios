import Eurofurence
import EurofurenceModel
import TestUtilities

extension StubNewsViewModel: RandomValueProviding {

    public static var random: StubNewsViewModel {
        return StubNewsViewModel(components: .random)
    }

}

extension StubNewsViewModel.Component: RandomValueProviding {

    public static var random: StubNewsViewModel.Component {
        return StubNewsViewModel.Component(title: .random, numberOfItems: .random)
    }

}
