import UIKit

public struct DissolvingTitleLabelContext: DissolvingTitleContext {
    
    public let label: UILabel
    
    public init(label: UILabel) {
        self.label = label
    }
    
    public var title: String? {
        label.text
    }
    
    public var contextualViewFrameRelativeToWindow: CGRect {
        label.convert(label.frame, to: nil)
    }
    
}
