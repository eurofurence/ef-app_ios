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
    
    override public func show(_ vc: UIViewController, sender: Any?) {
        if let child = children.first {
            child.show(vc, sender: sender)
        } else {
            super.show(vc, sender: sender)
        }
    }
    
    override public func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        if let child = children.first {
            child.showDetailViewController(vc, sender: sender)
        } else {
            super.show(vc, sender: sender)
        }
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
