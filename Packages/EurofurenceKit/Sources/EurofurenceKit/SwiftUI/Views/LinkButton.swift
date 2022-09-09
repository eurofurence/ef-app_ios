import SwiftUI

/// A `View` for rendering `Link`s from the model in a consistent fashion.
public struct LinkButton: View {
    
    @Environment(\.openURL) private var openURL
    @ObservedObject private var link: EurofurenceKit.Link
    
    public init(link: EurofurenceKit.Link) {
        self.link = link
    }
    
    public var body: some View {
        Button {
            if let url = URL(string: link.target) {
                openURL(url)
            }
        } label: {
            Text(link.name ?? "")
                .multilineTextAlignment(.leading)
        }
        .frame(minHeight: 44)
    }
    
}
