import ObservedObject

public protocol YourEurofurenceWidgetViewModel: ObservedObject {
    
    var prompt: String { get }
    var supplementaryPrompt: String { get }
    var isHighlightedForAttention: Bool { get }
    
    func showPersonalisedContent()
    
}
