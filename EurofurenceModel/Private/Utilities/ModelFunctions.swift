import Foundation

func not<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> Bool {
    return { (element) in return !predicate(element) }
}
