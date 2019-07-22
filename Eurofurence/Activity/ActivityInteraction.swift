struct ActivityInteraction: Interaction {
    
    var activity: Activity
    
    func activate() {
        activity.becomeCurrent()
    }
    
    func deactivate() {
        activity.resignCurrent()
    }
    
}
