import EurofurenceApplication

class CapturingTabNavigator: TabNavigator {
    
    private(set) var didMoveToTab = false
    func moveToTab() {
        didMoveToTab = true
    }
    
}
