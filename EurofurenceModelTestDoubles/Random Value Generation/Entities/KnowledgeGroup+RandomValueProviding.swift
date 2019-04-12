import EurofurenceModel
import Foundation
import TestUtilities

extension KnowledgeGroup: RandomValueProviding {

    public static var random: KnowledgeGroup {
        return KnowledgeGroup(identifier: .random,
                              title: .random,
                              groupDescription: .random,
                              fontAwesomeCharacterAddress: .random,
                              order: .random,
                              entries: .random)
    }

}
