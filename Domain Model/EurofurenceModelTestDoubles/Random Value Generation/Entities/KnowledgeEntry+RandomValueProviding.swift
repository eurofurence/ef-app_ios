import EurofurenceModel
import Foundation
import TestUtilities

extension KnowledgeEntry: RandomValueProviding {

    public static var random: KnowledgeEntry {
        return KnowledgeEntry(identifier: .random, title: .random, order: .random, contents: .random, links: .random)
    }

}
