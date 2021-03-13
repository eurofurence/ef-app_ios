struct ActivityInteraction: Interaction {
    
    var activity: Activity
    var donation: ActivityDonation
    
    func donate() {
        donation.donate()
    }
    
    func activate() {
        activity.becomeCurrent()
    }
    
    func deactivate() {
        activity.resignCurrent()
    }
    
}
