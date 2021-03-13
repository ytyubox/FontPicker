import FontPicker
import LoadingSystem
import TestUtils
import XCTest


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

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let variants = [
            makeVariant(name: "variant1", fileURL: URL(string: "https://variants1.com")!),
            makeVariant(name: "variant2", fileURL: URL(string: "https://variants2.com")!)
        ]
        let item1 = makeItem(name: "Item01",
                             variants: variants,
                             subsets: ["Subset1"],
                             category: "category1"

        )

        let item2 = makeItem(name: "Item02",
                             variants: variants,
                             subsets: ["Subset2"],
                             category: "category2"

        )

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: SUT? = RemoteFontLoader(url: url, client: client)

        var capturedResults = [SUT.Outcome]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }


    // MARK: - Helper

    private typealias SUT = RemoteFontLoader
    private typealias TheResult = Result<SUT.Output, RemoteError>
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFontLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private func makeItemsJSON(kind: String = "Any kind", _ items: [[String: Any]]) -> Data {
        let json: [String: Any] = ["kind": kind, "items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func makeItem(name: String, variants: [Variant], subsets: [String], category: String) -> (model: Font, json: [String: Any]) {
        let item = Font(name: name, variants: variants, subsets: subsets, category: category)
        let variantJSON = makeVariantJSON(variants)
        let json:[String: Any] = [
            "family": name,
            "variants": variantJSON["variants"],
            "subsets": subsets,
            "version": "AnyVersion",
            "lastModified": "AnyLastModified",
            "files": variantJSON["files"],
            "category": category,
            "kind": "AnyKind",
        ].compactMapValues { $0 }
        dump(json)
        return (item, json)
    }
    private func makeVariant(name: String, fileURL: URL) -> Variant {
        Variant(name: name, fileURL: fileURL)
    }
    private func makeVariantJSON(_ variants: [Variant]) -> [String: Any] {
        let pairsGroup = Dictionary(grouping: variants, by: {$0.name})
        let pairs = pairsGroup.mapValues{
            (value:[Variant]) in
            value.map(\.fileURL).map(\.absoluteString).joined()
        }
        let json:[String:Any] = [
            "variants":variants.map(\.name),
            "files": pairs
        ]
        
        return json
        
    }
    private func expect(_ sut: SUT, toCompleteWith expectedResult: TheResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as SUT.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private class HTTPClientSpy: HTTPClient {
        private struct Task: HTTPClientTask {
            let callback: () -> Void
            func cancel() { callback() }
        }

        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        private(set) var cancelledURLs = [URL]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
}
