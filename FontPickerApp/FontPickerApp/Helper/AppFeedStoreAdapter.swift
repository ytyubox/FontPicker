//
/*
 *		Created by 游宗諭 in 2021/3/12
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import CoreData
import LoadingSystem
import FontPicker

typealias Item = CachedItem<LocalFont>
typealias RetrievalItemResult = Result<Item?, Error>
typealias RetrievalItemCompletion = (RetrievalItemResult) -> Void


class AppFontStoreAdapter: FontStore, FontFileStore {
    init?() {
        do {
            self.store = try CoreDataFontStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("font-store.sqlite"))
        } catch {
            return nil
        }
    }
    let store:CoreDataFontStore
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        store.insert(data, for: url, completion: completion)
    }

    func retrieve(dataForURL url: URL, completion: @escaping (FontFileStore.RetrievalResult) -> Void) {
        store.retrieve(dataForURL: url, completion: completion)
    }

    func deleteCached(completion: @escaping DeletionCompletion) {
        store.deleteCached(completion: completion)
    }

    func insert(_ font: [LocalFont], timestamp: Date, completion: @escaping InsertionCompletion) {
        store.insert(font, timestamp: timestamp, completion: completion)
    }
  
    func retrieve(completion: @escaping RetrievalItemCompletion) {
        store.retrieve(completion: completion)
    }
}

final class NullStore: FontStore, FontFileStore {
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }

    func retrieve(dataForURL url: URL, completion: @escaping (FontFileStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }

    func deleteCached(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }

    func insert(_ font: [LocalFont], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }

    func retrieve(completion: @escaping RetrievalItemCompletion) {
        completion(.success(.none))
    }
    
}
