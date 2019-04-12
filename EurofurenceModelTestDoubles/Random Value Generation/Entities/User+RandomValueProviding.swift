import EurofurenceModel
import TestUtilities

extension User: RandomValueProviding {

    public static var random: User {
        return User(registrationNumber: .random, username: .random)
    }

}
