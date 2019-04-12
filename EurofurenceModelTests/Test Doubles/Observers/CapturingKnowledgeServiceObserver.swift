import EurofurenceModel
import Foundation

class CapturingKnowledgeServiceObserver: KnowledgeServiceObserver {

    private(set) var capturedGroups: [KnowledgeGroup] = []
    private(set) var wasProvidedWithEmptyGroups = false
    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup]) {
        wasProvidedWithEmptyGroups = wasProvidedWithEmptyGroups || groups.isEmpty
        capturedGroups = groups
    }

}
