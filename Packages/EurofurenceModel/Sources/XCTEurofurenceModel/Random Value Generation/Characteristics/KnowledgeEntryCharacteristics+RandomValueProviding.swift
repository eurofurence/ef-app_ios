import EurofurenceModel
import Foundation
import TestUtilities

extension KnowledgeEntryCharacteristics: RandomValueProviding {
    
    public static var random: KnowledgeEntryCharacteristics {
        let links = [LinkCharacteristics].random.sorted()
        return KnowledgeEntryCharacteristics(identifier: .random,
                                             groupIdentifier: .random,
                                             title: .random,
                                             order: .random,
                                             text: .random,
                                             links: links,
                                             imageIdentifiers: .random)
    }
    
}
