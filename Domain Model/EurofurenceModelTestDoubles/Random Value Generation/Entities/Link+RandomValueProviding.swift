import EurofurenceModel
import Foundation
import TestUtilities

extension Link: RandomValueProviding {

    public static var random: Link {
        return Link(name: .random, type: .webExternal, contents: Int.random)
    }

}
