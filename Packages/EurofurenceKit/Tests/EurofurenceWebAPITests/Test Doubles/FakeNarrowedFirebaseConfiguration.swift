@testable import EurofurenceWebAPI

class FakeNarrowedFirebaseConfiguration: NarrowedFirebaseConfiguration {
    
    private var values = [String: NarrowedFirebaseConfiguredValue]()
    
    func remotelyConfiguredValue(forKey key: String) -> NarrowedFirebaseConfiguredValue? {
        values[key]
    }
    
    private(set) var toldToAcquireRemoteValues = false
    func acquireRemoteValues() async {
        toldToAcquireRemoteValues = true
    }
    
    func stub(_ number: NSNumber, forKey key: String) {
        values[key] = StubbedNumberFirebaseConfiguredValue(numberValue: number)
    }
    
    private struct StubbedNumberFirebaseConfiguredValue: NarrowedFirebaseConfiguredValue {
        
        var numberValue: NSNumber
        
    }
    
}
