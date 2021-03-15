import UIKit

protocol DissolvingTitleContext {
    
    var title: String? { get }
    var contextualViewFrameRelativeToWindow: CGRect { get }
    
}
