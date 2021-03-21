import EurofurenceApplication

class CapturingTabWireframe: TabWireframe {
    
    private(set) var activated = false
    func activate() {
        activated = true
    }
    
}
