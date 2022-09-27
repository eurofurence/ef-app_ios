import SwiftUI

struct PannableFullScreenImage<Content>: View where Content: View {
    
    var image: Content
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            if isPresented {
                PannableView(image)
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Button {
                        withAnimation {
                            isPresented.toggle()
                        }
                    } label: {
                        SwiftUI.Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.secondary)
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
    
}
