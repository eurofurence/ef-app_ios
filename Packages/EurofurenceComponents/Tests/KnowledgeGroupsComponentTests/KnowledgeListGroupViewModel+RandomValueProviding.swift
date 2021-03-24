import KnowledgeGroupsComponent
import TestUtilities

extension KnowledgeListGroupViewModel: RandomValueProviding {

    public static var random: KnowledgeListGroupViewModel {
        return KnowledgeListGroupViewModel(
            title: .random,
            fontAwesomeCharacter: .random,
            groupDescription: .random
        )
    }

}
