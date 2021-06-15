import UIKit

public class RootContainerViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
}

// MARK: - RootContainerViewController + ReplaceRootWireframe

extension RootContainerViewController: ReplaceRootWireframe {
    
    public func replaceRoot(with newRoot: UIViewController) {
        if let existingRoot = children.first {
            existingRoot.willMove(toParent: nil)
            existingRoot.view.removeFromSuperview()
            existingRoot.removeFromParent()
            existingRoot.didMove(toParent: nil)
        }
        
        newRoot.willMove(toParent: self)
        view.addSubview(newRoot.view)
        addChild(newRoot)
        newRoot.didMove(toParent: self)
    }
    
}
