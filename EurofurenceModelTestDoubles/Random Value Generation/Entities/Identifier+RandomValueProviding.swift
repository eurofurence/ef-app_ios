import EurofurenceModel
import TestUtilities

extension Identifier: RandomValueProviding {

    public static var random: Identifier {
        return Identifier(.random)
    }

}
