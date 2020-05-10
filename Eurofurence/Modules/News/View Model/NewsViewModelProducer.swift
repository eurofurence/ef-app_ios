protocol NewsViewModelProducer {

    func subscribeViewModelUpdates(_ delegate: NewsViewModelRecipient)
    func refresh()

}

protocol NewsViewModelRecipient {

    func viewModelDidUpdate(_ viewModel: NewsViewModel)
    func refreshDidBegin()
    func refreshDidFinish()

}
