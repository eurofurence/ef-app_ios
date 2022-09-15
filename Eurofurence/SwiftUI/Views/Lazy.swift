import SwiftUI

struct Lazy<Body>: View where Body: View {
    
    private let lazyBody: () -> Body
    
    init(@ViewBuilder _ body: @escaping () -> Body) {
        self.lazyBody = body
    }
    
    var body: Body {
        lazyBody()
    }
    
}
