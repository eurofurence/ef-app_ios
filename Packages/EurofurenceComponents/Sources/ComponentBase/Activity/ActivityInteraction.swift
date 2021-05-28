public struct ActivityInteraction: Interaction {
    
    private let activity: Activity
    private let donation: ActivityDonation
    
    public init(activity: Activity, donation: ActivityDonation) {
        self.activity = activity
        self.donation = donation
    }
    
    public func donate() {
        donation.donate()
    }
    
    public func activate() {
        activity.becomeCurrent()
    }
    
    public func deactivate() {
        activity.resignCurrent()
    }
    
}
