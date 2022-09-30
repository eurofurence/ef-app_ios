import EurofurenceKit
import SwiftUI

struct DealerView: View {
    
    @ObservedObject var dealer: Dealer
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle(dealer.name)
    }
    
}

struct DealerView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            let dealer = model.dealer(for: .animasAnimus)
            
            NavigationView {
                DealerView(dealer: dealer)
            }
            .previewDisplayName(dealer.name)
        }
    }
    
}
