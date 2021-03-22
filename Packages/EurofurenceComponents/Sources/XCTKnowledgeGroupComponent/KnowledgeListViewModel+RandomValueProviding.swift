import KnowledgeGroupComponent
import TestUtilities

extension KnowledgeListEntryViewModel: RandomValueProviding {

    public static var random: KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: .random)
    }

}
