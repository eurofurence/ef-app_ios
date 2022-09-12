import SwiftUI

struct SelectableRow<ID, Label>: View where ID: Identifiable, Label: View {
    
    var tag: ID?
    @Binding var selection: ID?
    var content: () -> Label
    
    var body: some View {
        Button {
            selection = tag
        } label: {
            HStack {
                content()
                Spacer()
                
                if selection?.id == tag?.id {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
}
