import UIKit

@IBDesignable
class PlaceholderTextView: UITextView {
    
    // MARK: Public
    
    @IBInspectable var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            recomputePlaceholderLayout()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recomputePlaceholderLayout()
    }
    
    override var accessibilityLabel: String? {
        get {
            let result: String?
            if isPlaceholderNeedingDisplay(), let placeholderText = placeholderLabel.text {
                result = "\(placeholderText)."
            } else {
                result = super.accessibilityLabel
            }
            
            return result
        }
        set {
            super.accessibilityLabel = newValue
        }
    }
    
    private func calculatePlaceholderIntrinsictContentSize() -> CGSize {
        var intrinsicContentSize = placeholderLabel.intrinsicContentSize
        intrinsicContentSize.height += textContainerInset.top + textContainerInset.bottom
        
        return intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        if isPlaceholderNeedingDisplay() {
            return calculatePlaceholderIntrinsictContentSize()
        } else {
            return super.intrinsicContentSize
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    // MARK: Private
    
    private var textUpdateNotification: NSObjectProtocol?
    private var placeholderConstraints: [NSLayoutConstraint] = []
    private let placeholderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isAccessibilityElement = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }()
    
    private func setUp() {
        insertPlaceholderView()
        registerForTextUpdates()
        updatePlaceholderVisibility()
    }
    
    private func registerForTextUpdates() {
        let notificationHandler: (Notification) -> Void = { (_) in self.updatePlaceholderVisibility() }
        
        textUpdateNotification = NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification,
                                                                        object: self,
                                                                        queue: .main,
                                                                        using: notificationHandler)
    }
    
    private func recomputePlaceholderLayout() {
        guard subviews.contains(placeholderLabel) else { return }
        updatePlaceholderLabelConstraints()
        invalidateIntrinsicContentSize()
    }
    
    private func updatePlaceholderVisibility() {
        let targetAlpha: CGFloat = isPlaceholderNeedingDisplay() ? 1 : 0
        guard targetAlpha != placeholderLabel.alpha else { return }
        
        invalidateIntrinsicContentSize()
        
        UIView.animate(withDuration: 1 / 3, delay: 0, options: [.beginFromCurrentState], animations: {
            self.placeholderLabel.alpha = targetAlpha
        })
    }
    
    private func isPlaceholderNeedingDisplay() -> Bool {
        return text.isEmpty
    }
    
    private func insertPlaceholderView() {
        addSubview(placeholderLabel)
        updatePlaceholderLabelConstraints()
    }
    
    private func updatePlaceholderLabelConstraints() {
        let lineInsets = contentInset
        let lineFragmentPadding = textContainer.lineFragmentPadding
        let sumOfHorizontalInsets = lineInsets.left + lineInsets.right + lineFragmentPadding * 2
        
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - lineFragmentPadding * 2.0
        
        let placeholderConstraints: [NSLayoutConstraint] = [
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: lineInsets.left + lineFragmentPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: lineInsets.right + lineFragmentPadding),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: textContainerInset.bottom),
            placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -sumOfHorizontalInsets)
        ]
        
        NSLayoutConstraint.deactivate(self.placeholderConstraints)
        NSLayoutConstraint.activate(placeholderConstraints)
        self.placeholderConstraints = placeholderConstraints
    }
    
}
