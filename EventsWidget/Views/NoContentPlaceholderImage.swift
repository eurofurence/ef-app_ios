import SwiftUI

struct NoContentPlaceholderImage: View {
    
    var body: some View {
        Image("No Content Placeholder")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
    }
    
}
