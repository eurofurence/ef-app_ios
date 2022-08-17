import ComponentBase
import SwiftUI

struct AppIconPickerView<ViewModel>: View where ViewModel: AppIconsViewModel {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.icons) { (icon) in
                AppIconCell(viewModel: icon)
            }
        }
    }
    
}

private struct AppIconCell<ViewModel>: View where ViewModel: AppIconViewModel {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {            
                viewModel.selectAsAppIcon()
            }
        } label: {
            HStack {
                Image(decorative: viewModel.imageName, bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
                    .cornerRadius(14)
                
                Spacer()
                
                Text(verbatim: viewModel.displayName)
                    .font(.body)
                
                if viewModel.isCurrentAppIcon {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(.pantone330U)
                }
            }
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
    }
    
}

struct AppIconPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppIconPickerView(viewModel: DesignTimeAppIconsViewModel.sample)
    }
    
}
