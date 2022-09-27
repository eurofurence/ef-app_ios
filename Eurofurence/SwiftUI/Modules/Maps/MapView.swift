import EurofurenceKit
import SwiftUI

struct MapView: View {
    
    @ObservedObject var map: Map
    
    var body: some View {
        ZStack(alignment: .center) {
            if let mapImage = map.graphic.image {
                PannableView(mapImage.resizable().aspectRatio(contentMode: .fit))
            }
        }
        .navigationTitle(map.mapDescription)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {            
                MapView(map: model.map(for: .venue))
            }
        }
    }
    
}
