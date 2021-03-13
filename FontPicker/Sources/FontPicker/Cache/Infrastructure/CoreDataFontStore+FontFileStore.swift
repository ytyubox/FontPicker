import Foundation
import LoadingSystem

extension CoreDataFontStore: FontFileStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (DataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                let managedVariant = try ManagedVariant.newUniqueInstance(with: url, in: context)
                managedVariant.url = url
                managedVariant.data = data
                try context.save()
            })
        }
    }

    public func retrieve(dataForURL url: URL, completion: @escaping (DataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedVariant.first(with: url, in: context)?.data
            })
        }
    }
}
