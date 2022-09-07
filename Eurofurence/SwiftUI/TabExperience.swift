import EurofurenceKit
import SwiftUI

struct TabExperience: View {
    
    private enum Tab: Hashable {
        case news
        case schedule
        case dealers
        case information
        case more
    }
    
    @State private var selectedTab: Tab = .news
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                NewsView()
                    .navigationTitle("News")
            }
            .tabItem {
                TabItem(title: Text("News"), image: Image(systemName: "newspaper"))
            }
            .tag(Tab.news)
            
            NavigationView {
                ScheduleView()
                    .navigationTitle("Schedule")
            }
            .tabItem {
                TabItem(title: Text("Schedule"), image: Image(systemName: "calendar"))
            }
            .tag(Tab.schedule)
            
            NavigationView {
                DealersView()
                    .navigationTitle("Dealers")
            }
            .tabItem {
                TabItem(title: Text("Dealers"), image: Image(systemName: "cart"))
            }
            .tag(Tab.information)
            
            NavigationView {
                InformationView()
                    .navigationTitle("Information")
            }
            .tabItem {
                TabItem(title: Text("Information"), image: Image(systemName: "info.circle"))
            }
            .tag(Tab.information)
            
            NavigationView {
                MoreView()
                    .navigationTitle("More")
            }
            .tabItem {
                TabItem(title: Text("More"), image: Image(systemName: "ellipsis"))
            }
            .tag(Tab.more)
        }
    }
    
}

struct Placeholder_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            TabExperience()
        }
    }
    
}
