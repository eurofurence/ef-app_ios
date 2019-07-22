import EurofurenceModel

struct DonateIntentDealerInteractionRecorder: DealerInteractionRecorder {
    
    var viewDealerIntentDonor: ViewDealerIntentDonor
    var dealersService: DealersService
    var activityFactory: ActivityFactory
    
    func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
        guard let entity = dealersService.fetchDealer(for: dealer) else { return nil }
        
        let intentDefinition = ViewDealerIntentDefinition(identifier: dealer, dealerName: entity.preferredName)
        viewDealerIntentDonor.donate(intentDefinition)
        
        let activityTitle = String.viewDealer(named: entity.preferredName)
        let url = entity.makeContentURL()
        let activity = activityFactory.makeActivity(type: "org.eurofurence.activity.view-dealer", title: activityTitle, url: url)
        
        return ActivityInteraction(activity: activity)
    }
    
}
