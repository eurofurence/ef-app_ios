import EurofurenceModel
import TestUtilities

extension ConventionIdentifier: RandomValueProviding {
    
    public static var random: ConventionIdentifier {
        return ConventionIdentifier(identifier: .random)
    }
    
}
