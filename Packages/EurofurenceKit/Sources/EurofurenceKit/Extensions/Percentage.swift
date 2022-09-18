/// A value used to represent a percentage in the range 0 to 1, inclusive.
@propertyWrapper public struct Percentage<Value> where Value: FloatingPoint {
    
    public init(defaultValue: Value) {
        self.value = defaultValue
    }
    
    private var value: Value
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            var candidate = newValue
            if newValue < 0 {
                candidate = 0
            }
            
            if newValue > 1 {
                candidate = 1
            }
            
            value = candidate
        }
    }
    
}
