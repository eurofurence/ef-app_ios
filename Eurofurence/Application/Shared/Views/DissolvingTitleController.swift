import UIKit

struct DissolvingTitleController {
    
    private enum TitleState {
        case visible(opacity: CGFloat)
        case hidden
    }
    
    private let scrollView: UIScrollView
    private let titleLabel: UILabel
    private let titleView = DissolvingTitleLabel(frame: .zero)
    private var contentOffsetObservation: NSKeyValueObservation?
    
    init(scrollView: UIScrollView, navigationItem: UINavigationItem, titleLabel: UILabel, accessibilityIdentifier: String) {
        self.scrollView = scrollView
        self.titleLabel = titleLabel
        
        titleView.accessibilityIdentifier = accessibilityIdentifier
        titleView.text = titleLabel.text
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
        let titleLabelFrame = titleLabel.convert(titleLabel.frame, to: nil)
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
