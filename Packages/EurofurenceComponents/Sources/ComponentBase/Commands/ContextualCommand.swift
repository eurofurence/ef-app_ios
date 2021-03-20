import UIKit

public struct ContextualCommand {
    
    public var title: String
    public var sfSymbol: String?
    public var run: (Any?) -> Void
    
    public init(title: String, sfSymbol: String? = nil, run: @escaping (Any?) -> Void) {
        self.title = title
        self.sfSymbol = sfSymbol
        self.run = run
    }
    
}

// MARK: - Creating UIActions From Commands

@available(iOS 13.0, *)
extension ContextualCommand {
    
    public func makeUIAction(sender: Any?) -> UIAction {
        UIAction(title: title, image: UIImage(systemName: sfSymbol ?? ""), handler: { (_) in
            self.run(sender)
        })
    }
    
}
