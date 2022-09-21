import SwiftUI

struct FeedbackSentPopover: View {
    
    @ScaledMetric(relativeTo: .body) private var imageHeight: CGFloat = 125
    @Environment(\.successNotificationHaptic) private var successNotificationHaptic
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .symbolRenderingMode(.multicolor)
                .aspectRatio(contentMode: .fit)
                .frame(height: imageHeight)
            
            Text("Thanks for your feedback!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .onAppear {
            successNotificationHaptic()
        }
    }
    
}

struct FeedbackSentPopover_Previews: PreviewProvider {
    
    static var previews: some View {
        FeedbackSentPopover()
            .previewLayout(.sizeThatFits)
    }
    
}
