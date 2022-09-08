import EurofurenceKit

@MainActor
struct AppModel {
    
    static let shared = AppModel()
    let model: EurofurenceModel
    
    private init() {
        model = EurofurenceModel()
    }
    
}
