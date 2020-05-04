import Eurofurence

class CapturingNewsPresentation: NewsPresentation {
    
    private(set) var didShowNews = false
    func showNews() {
        didShowNews = true
    }
    
}
