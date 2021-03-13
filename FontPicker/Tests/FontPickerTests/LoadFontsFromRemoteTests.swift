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

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    // MARK: - Helper

    private typealias SUT = RemoteFontLoader
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFontLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private final class HTTPClientSpy: HTTPClient {
        private(set) var requestedURLs = [URL]()

        func get(from url: URL, completion _: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            requestedURLs.append(url)
            return Task()
        }

        private struct Task: HTTPClientTask {
            func cancel() {}
        }
    }
}
