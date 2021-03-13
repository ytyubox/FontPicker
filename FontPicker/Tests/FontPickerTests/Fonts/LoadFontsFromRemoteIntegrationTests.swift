//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import XCTest
import LoadingSystem
import FontPicker

final class LoadFontsFromRemoteIntegrationTests: XCTestCase {
    override func setUpWithError() throws {
        if APIKEY.isEmpty {
            throw XCTSkip("Set API in the Helper column, ⚠️ remember don't commit it ⚠️ ")
        }
    }

    func test_endToEndTestServerGETResult_WillSuccessfullyDecode() throws {
        let receivedResult = getFontResult()
        switch receivedResult {
        case let .success(fonts):
            XCTAssertFalse(fonts.isEmpty, "Expected 8 items in the test account feed")
           

        case let .failure(error):
            XCTFail("Expected successful feed result, got \(error) instead")

        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }

    // MARK: - Helpers
    private let APIKEY = ""
    private func getFontResult(file _: StaticString = #file, line _: UInt = #line) -> RemoteFontLoader.Outcome? {
        let loader = RemoteFontLoader(url: theRealGoogleFontServerURL, client: ephemeralClient())
        trackForMemoryLeaks(loader)
        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemoteFontLoader.Outcome?
        loader.load { result in
            receivedResult = result.mapError { $0 }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return receivedResult
    }



    private var theRealGoogleFontServerURL: URL {
        URL(string: "https://www.googleapis.com/webfonts/v1/webfonts?key=\(APIKEY)")!
    }

    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }

   
}
