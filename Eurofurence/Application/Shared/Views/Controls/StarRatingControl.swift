import UIKit

class StarRatingControl: UIControl {
    
    private let stackView = UIStackView(frame: .zero)
    private let numberOfStars = 5
    private var selectionChangedFeedback: UISelectionFeedbackGenerator?
    private var previousValueWhileTouchesMoving: Int?
    
    override var isEnabled: Bool {
        didSet {
            updateCurrentTintColor()
        }
    }
    
    var value: Int = 3 {
        didSet {
            switch validate(value: value) {
            case .valid:
                valueDidChange()
                
            case .invalid(let suggestion):
                value = suggestion
            }
        }
    }
    
    var percentageValue: Float {
        return Float(value) / Float(numberOfStars)
    }
    
    var enabledTintColor: UIColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1) {
        didSet {
            if isEnabled {
                tintColor = enabledTintColor
            }
        }
    }
    
    var disabledTintColor: UIColor = .lightGray {
        didSet {
            if !isEnabled {
                tintColor = disabledTintColor
            }
        }
    }
    
    private enum ValidationResult {
        case valid
        case invalid(suggestion: Int)
    }
    
    private func validate(value: Int) -> ValidationResult {
        guard value > 1 else { return .invalid(suggestion: 1) }
        guard value <= numberOfStars else { return .invalid(suggestion: numberOfStars) }
        
        return .valid
    }
    
    private func valueDidChange() {
        sendActions(for: .valueChanged)
        updateAccessibilityValue()
        repaintStars(value: value)
    }
    
    private func repaintStars(value: Int) {
        let asStarView: (UIView) -> StarView? = { $0 as? StarView }
        let filled = stackView.arrangedSubviews[0..<value].compactMap(asStarView)
        let empty = stackView.arrangedSubviews[value..<numberOfStars].compactMap(asStarView)
        
        filled.forEach({ $0.isFilled = true })
        empty.forEach({ $0.isFilled = false })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        setUpStackView()
        insertStarViews()
        updateCurrentTintColor()
        setUpAccessibility()
        repaintStars(value: value)
    }
    
    private func setUpStackView() {
        insertStackViewIntoViewHiearchy()
        adjustStackViewForHorizontalStarLayout()
    }
    
    private func insertStackViewIntoViewHiearchy() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    private func adjustStackViewForHorizontalStarLayout() {
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func insertStarViews() {
        for _ in 0..<numberOfStars {
            let starView = StarView(frame: .zero)
            stackView.addArrangedSubview(starView)
        }
    }
    
    private func updateCurrentTintColor() {
        if isEnabled {
            applyDefaultStarTintColor()
        } else {
            applyDisabledStarTintColor()
        }
    }
    
    private func applyDefaultStarTintColor() {
        tintColor = enabledTintColor
    }
    
    private func applyDisabledStarTintColor() {
        tintColor = disabledTintColor
    }
    
    private func setUpAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits.formUnion(.adjustable)
        accessibilityLabel = "Star Rating"
    }
    
    private func updateAccessibilityValue() {
        accessibilityValue = "\(value) of \(numberOfStars)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        guard touches.count == 1 else { return }
        guard let touch = touches.first else { return }
        
        selectionChangedFeedback = UISelectionFeedbackGenerator()
        playSelectionChangedFeedback()
        
        let point = touch.location(in: self)
        let valueForLocation = calculateControlValue(for: point)
        previousValueWhileTouchesMoving = valueForLocation
        repaintStars(value: valueForLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        guard touches.count == 1 else { return }
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        let valueForLocation = calculateControlValue(for: point)
        
        if previousValueWhileTouchesMoving != valueForLocation {
            playSelectionChangedFeedback()
            previousValueWhileTouchesMoving = valueForLocation
        }
        
        repaintStars(value: valueForLocation)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        
        teardownTouchTrackingFields()
        repaintStars(value: value)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        guard touches.count == 1 else { return }
        guard let touch = touches.first else { return }
        
        teardownTouchTrackingFields()
        
        let point = touch.location(in: self)
        value = calculateControlValue(for: point)
    }
    
    private func calculateControlValue(for point: CGPoint) -> Int {
        let widthRatio = point.x / bounds.width
        let estimatedValue = ceil(widthRatio * CGFloat(numberOfStars))
        
        return max(1, min(numberOfStars, Int(estimatedValue)))
    }
    
    private func playSelectionChangedFeedback() {
        selectionChangedFeedback?.selectionChanged()
        selectionChangedFeedback?.prepare()
    }
    
    private func teardownTouchTrackingFields() {
        selectionChangedFeedback = nil
        previousValueWhileTouchesMoving = nil
    }
    
    override var intrinsicContentSize: CGSize {
        return stackView.intrinsicContentSize
    }
    
    override func accessibilityIncrement() {
        value += 1
    }
    
    override func accessibilityDecrement() {
        value -= 1
    }
    
    private class StarView: UIImageView {
        
        var isFilled: Bool = true {
            didSet {
                updateStarGraphic()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setUp()
        }
        
        private func setUp() {
            adjustImageViewForPresentingStar()
            updateStarGraphic()
        }
        
        private func adjustImageViewForPresentingStar() {
            contentMode = .center
        }
        
        private func updateStarGraphic() {
            if isFilled {
                image = UIImage(named: "Star_Filled")
            } else {
                image = UIImage(named: "Star_Empty")
            }
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 44, height: 44)
        }
        
    }
    
}
