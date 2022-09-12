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
                NewsLabel(isSelected: selectedTab == .news)
            }
            .tag(Tab.news)
            
            NavigationView {
                ScheduleView()
                    .navigationTitle("Schedule")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                ScheduleLabel(isSelected: selectedTab == .schedule)
            }
            .tag(Tab.schedule)
            
            NavigationView {
                DealersView()
                    .navigationTitle("Dealers")
            }
            .tabItem {
                DealersLabel(isSelected: selectedTab == .dealers)
            }
            .tag(Tab.information)
            
            NavigationView {
                InformationView()
                    .navigationTitle("Information")
            }
            .tabItem {
                InformationLabel(isSelected: selectedTab == .information)
            }
            .tag(Tab.information)
            
            NavigationView {
                MoreView()
                    .navigationTitle("More")
            }
            .tabItem {
                MoreLabel(isSelected: selectedTab == .more)
            }
            .tag(Tab.more)
        }
    }
    
}

struct TabExperience_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            TabExperience()
        }
    }
    
}
