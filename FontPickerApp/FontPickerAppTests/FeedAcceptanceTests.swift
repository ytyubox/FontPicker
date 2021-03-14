//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
@testable import FontPickerApp
import FontPickeriOS
import XCTest

func fontToData(font: UIFont) -> Data {
    "\(font)".data(using: .utf8)!
}

class FontAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFontWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .onlineFont(transformer: fontToData(font:), response), store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFontImageViews(), 2)
        XCTAssertEqual(feed.renderedFontImageData(at: 0), makeFont())
        XCTAssertEqual(feed.renderedFontImageData(at: 1), makeFont())
    }

    func test_onLaunch_displaysCachedRemoteFontWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFontStore.empty
        let onlineFont = launch(httpClient: .onlineFont(transformer: fontToData(font:), response), store: sharedStore)
        onlineFont.simulateFontImageViewVisible(at: 0)
        onlineFont.simulateFontImageViewVisible(at: 1)

        let offlineFont = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFont.numberOfRenderedFontImageViews(), 2)
        XCTAssertEqual(offlineFont.renderedFontImageData(at: 0), makeFont())
        XCTAssertEqual(offlineFont.renderedFontImageData(at: 1), makeFont())
    }

    func test_onLaunch_displaysEmptyFontWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFontImageViews(), 0)
    }

    func test_onEnteringBackground_deletesExpiredFontCache() {
        let store = InMemoryFontStore.withExpiredFontCache

        enterBackground(with: store)

        XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }

    func test_onEnteringBackground_keepsNonExpiredFontCache() {
        let store = InMemoryFontStore.withNonExpiredFontCache

        enterBackground(with: store)

        XCTAssertNotNil(store.feedCache, "Expected to keep non-expired cache")
    }

    // MARK: - Helpers

    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFontStore = .empty
    ) -> FontViewController {
        let container = Container(httpClient: httpClient, store: InMemoryStoreAddapter(store: store))
        let sut = SceneDelegate(root: container)
        sut.window = UIWindow()
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! FontViewController
    }

    private func enterBackground(with store: InMemoryFontStore) {
        let container = Container(httpClient: HTTPClientStub.offline, store: InMemoryStoreAddapter(store: store))
        let sut = SceneDelegate(root: container)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }

    private func response(for url: URL) -> (UIFont, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> UIFont {
        switch url.absoluteString {
        case "http://image.com":
            return makeFont()

        default:
            return makeFont()
        }
    }

    private func makeFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16)
    }

    private func makeFont() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"],
        ]])
    }

    private class InMemoryStoreAddapter: FontStore, FontFileStore {
        init(store: InMemoryFontStore) {
            self.store = store
        }

        let store: InMemoryFontStore
        func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
            store.insert(data, for: url, completion: completion)
        }

        func retrieve(dataForURL url: URL, completion: @escaping (FontFileStore.RetrievalResult) -> Void) {
            store.retrieve(dataForURL: url, completion: completion)
        }

        func deleteCached(completion: @escaping DeletionCompletion) {
            store.deleteCached(completion: completion)
        }

        func insert(_ feed: [LocalFont], timestamp: Date, completion: @escaping InsertionCompletion) {
            store.insert(feed, timestamp: timestamp, completion: completion)
        }

        func retrieve(completion: @escaping RetrievalCompletion) {
            store.retrieve(completion: completion)
        }
    }
}
