import UIKit

struct DissolvingTitleLabelContext: DissolvingTitleContext {
    
    let label: UILabel
    
    var title: String? {
        label.text
    }
    
    var contextualViewFrameRelativeToWindow: CGRect {
        label.convert(label.frame, to: nil)
    }
    
}
