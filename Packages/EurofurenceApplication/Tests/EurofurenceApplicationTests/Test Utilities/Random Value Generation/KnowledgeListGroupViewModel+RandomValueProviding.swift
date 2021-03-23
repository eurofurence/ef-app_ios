import EurofurenceApplication
import KnowledgeGroupComponent
import KnowledgeGroupsComponent
import TestUtilities
import XCTKnowledgeGroupComponent

extension KnowledgeListGroupViewModel: RandomValueProviding {

    public static var random: KnowledgeListGroupViewModel {
        return KnowledgeListGroupViewModel(
            title: .random,
            fontAwesomeCharacter: .random,
            groupDescription: .random
        )
    }

}
