import Foundation
import LoadingSystem

extension CoreDataFontStore: FontFileStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (DataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedVariant.first(with: url, in: context)
                    .map {
                        $0.data = data
                        $0.url = url
                    }
                    .map(context.save)
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
