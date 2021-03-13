import Darwin
import EurofurenceApplication
import EurofurenceModel
import TestUtilities
import UIKit.UIImage

extension KnowledgeListGroupViewModel: RandomValueProviding {

    public static var random: KnowledgeListGroupViewModel {
        return KnowledgeListGroupViewModel(title: .random,
                                           fontAwesomeCharacter: .random,
                                           groupDescription: .random,
                                           knowledgeEntries: .random)
    }

}

extension KnowledgeListEntryViewModel: RandomValueProviding {

    public static var random: KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: .random)
    }

}
