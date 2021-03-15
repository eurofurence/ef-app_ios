public protocol NewsViewModelProducer {

    func subscribeViewModelUpdates(_ delegate: NewsViewModelRecipient)
    func refresh()

}

public protocol NewsViewModelRecipient {

    func viewModelDidUpdate(_ viewModel: NewsViewModel)
    func refreshDidBegin()
    func refreshDidFinish()

}
