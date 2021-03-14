//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import Foundation
import LoadingSystem

class InMemoryFontStore {
    typealias CachedFont = LoadingSystem.CachedItem<LocalFont>
    private(set) var feedCache: CachedFont?
    private var feedImageDataCache: [URL: Data] = [:]

    private init(feedCache: CachedFont? = nil) {
        self.feedCache = feedCache
    }
}

extension InMemoryFontStore: FontStore {
    typealias Local = LocalFont

    func deleteCached(completion: @escaping FontStore.DeletionCompletion) {
        feedCache = nil
        completion(.success(()))
    }

    func insert(_ feed: [LocalFont], timestamp: Date, completion: @escaping FontStore.InsertionCompletion) {
        feedCache = CachedFont(item: feed, timestamp: timestamp)
        completion(.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(feedCache))
    }
}

extension InMemoryFontStore: FontFileStore {
    func insert(_ data: Data, for url: URL, completion: @escaping (FontFileStore.InsertionResult) -> Void) {
        feedImageDataCache[url] = data
        completion(.success(()))
    }

    func retrieve(dataForURL url: URL, completion: @escaping (FontFileStore.RetrievalResult) -> Void) {
        completion(.success(feedImageDataCache[url]))
    }
}

extension InMemoryFontStore {
    static var empty: InMemoryFontStore {
        InMemoryFontStore()
    }

    static var withExpiredFontCache: InMemoryFontStore {
        InMemoryFontStore(feedCache: CachedFont(item: [], timestamp: Date.distantPast))
    }

    static var withNonExpiredFontCache: InMemoryFontStore {
        InMemoryFontStore(feedCache: CachedFont(item: [], timestamp: Date()))
    }
}
