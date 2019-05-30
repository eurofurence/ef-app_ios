import EurofurenceIntentDefinitions

struct DonateIntentCollectThemAllInteractionRecorder: CollectThemAllInteractionRecorder {
    
    func recordCollectThemAllInteraction() {
        guard #available(iOS 12.0, *) else { return }
        
        let intent = OpenCollectThemAllIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
}
