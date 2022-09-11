import SwiftUI

struct TabItem: View {
    
    var title: Text
    var image: Image
    
    var body: some View {
        Label {
            title
        } icon: {
            image
        }
    }
    
}
