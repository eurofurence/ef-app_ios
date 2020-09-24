import UIKit

protocol DissolvingTitleContext {
    
    var title: String? { get }
    var contextualViewFrame: CGRect { get }
    
}

struct DissolvingTitleLabelContext: DissolvingTitleContext {
    
    let label: UILabel
    
    var title: String? {
        label.text
    }
    
    var contextualViewFrame: CGRect {
        label.convert(label.frame, to: nil)
    }
    
}

struct DissolvingTitleController {
    
    private enum TitleState {
        case visible(opacity: CGFloat)
        case hidden
    }
    
    private let scrollView: UIScrollView
    private let context: DissolvingTitleContext
    private let titleView = DissolvingTitleLabel(frame: .zero)
    private var contentOffsetObservation: NSKeyValueObservation?
    
    init(scrollView: UIScrollView, navigationItem: UINavigationItem, accessibilityIdentifier: String, context: DissolvingTitleContext) {
        self.scrollView = scrollView
        self.context = context
        
        titleView.accessibilityIdentifier = accessibilityIdentifier
        titleView.text = context.title
        navigationItem.titleView = titleView
        
        contentOffsetObservation = scrollView.observe(\.contentOffset, changeHandler: scrollViewContentOffetChanged)
    }
    
    private func scrollViewContentOffetChanged(_ scrollView: UIScrollView, _ change: NSKeyValueObservedChange<CGPoint>) {
        updateNavigationTitle(contentOffset: scrollView.contentOffset)
    }
    
    private func updateNavigationTitle(contentOffset: CGPoint) {
        if case .visible(let opacity) = shouldShowNavigationTitle(contentOffset: contentOffset) {
            showTitle(opacity: opacity)
        } else {
            hideTitle()
        }
    }
    
    private func shouldShowNavigationTitle(contentOffset: CGPoint) -> TitleState {
        let titleLabelFrame = context.contextualViewFrame
        let titleLabelTop = titleLabelFrame.origin.y
        
        let navigationTitleFrame = titleView.convert(titleView.frame, to: nil)
        let additionalPaddingForAnimation: CGFloat = 20
        let navigationTitleBottom = navigationTitleFrame.origin.y + navigationTitleFrame.size.height + additionalPaddingForAnimation
        
        if titleLabelTop < navigationTitleBottom {
            let opacity = max(0, 1 - (titleLabelTop / navigationTitleBottom))
            return .visible(opacity: opacity)
        } else {
            return .hidden
        }
    }
    
    private func hideTitle() {
        titleView.isHidden = true
        titleView.alpha = 0
    }
    
    private func showTitle(opacity: CGFloat) {
        titleView.isHidden = false
        titleView.alpha = opacity
    }
    
}
