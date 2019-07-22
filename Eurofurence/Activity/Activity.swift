protocol Activity {
    
    func becomeCurrent()
    func resignCurrent()
    
    func markEligibleForPublicIndexing()
    func markEligibleForLocalIndexing()
    
}
