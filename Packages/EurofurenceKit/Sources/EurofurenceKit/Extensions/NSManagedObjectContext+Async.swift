import CoreData

extension NSManagedObjectContext {
    
    func performAsync<T>(block: @Sendable @escaping (NSManagedObjectContext) -> T) async -> T {
        return await withCheckedContinuation { (continuation: CheckedContinuation<T, Never>) in
            perform { [self] in
                let result = block(self)
                continuation.resume(returning: result)
            }
        }
    }
    
}
