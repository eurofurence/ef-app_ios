import UIKit

public protocol DissolvingTitleContext {
    
    var title: String? { get }
    var contextualViewFrameRelativeToWindow: CGRect { get }
    
}
