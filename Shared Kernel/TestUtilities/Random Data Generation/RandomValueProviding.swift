public protocol RandomValueProviding {

    static var random: Self { get }

}

public extension RandomValueProviding {

    func randomized(ifFalse predicate: @autoclosure () -> Bool) -> Self {
        return predicate() ? self : Self.random
    }

}
