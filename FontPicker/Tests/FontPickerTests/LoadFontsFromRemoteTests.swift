import FontPicker
import LoadingSystem
import TestUtils
import XCTest

public final class RemoteFontLoader: RemoteLoader<[RemoteFont]> {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client) { (_, _) -> [RemoteFont] in
            []
        }
    }
}

final class LoadFontsFromRemoteTests: XCTestCase {
    func test_FontLoaderAfterInitWillNotRequestAnyURL() {
        let client = HTTPClientSpy()
        _ = RemoteFontLoader(url: anyURL(), client: client)

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    // MARK: - Helper

    private final class HTTPClientSpy: HTTPClient {
        private(set) var requestedURLs = [URL]()

        func get(from _: URL, completion _: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            Task()
        }

        private struct Task: HTTPClientTask {
            func cancel() {}
        }
    }
}
