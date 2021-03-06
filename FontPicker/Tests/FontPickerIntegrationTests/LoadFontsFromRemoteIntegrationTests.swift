//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import FontPicker
import LoadingSystem
import TestUtils
import XCTest

final class LoadFontsFromRemoteIntegrationTests: XCTestCase {
    func test_endToEndTestServerGETResult_WillSuccessfullyDecode() throws {
        try throwIfNoAPIKEY()
        let receivedResult = getFontResult()
        switch receivedResult {
        case let .success(fonts):
            XCTAssertFalse(fonts.isEmpty, "Expected result is not empty")
            
        case let .failure(error):
            XCTFail("Expected successful font result, got \(error) instead")
            
        default:
            XCTFail("Expected successful font result, got no result instead")
        }
        remindIfAPIKEYShouldBeRemovedBeforeCommit()
    }
    
    func test_endToEndTestServerGETfontFileDataResult_matchesFixedTestAccountData() {
        switch getFontFileDataResult() {
        case let .success(data)?:
            XCTAssertFalse(data.isEmpty, "Expected non-empty file data")
            
        case let .failure(error)?:
            XCTFail("Expected successful file data result, got \(error) instead")
            
        default:
            XCTFail("Expected successful file data result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    /// ****************************************************
    ///
    ///            _____ _____   _  __________     __
    ///      /\   |  __ \_   _| | |/ /  ____\ \   / /
    ///     /  \  | |__) || |   | ' /| |__   \ \_/ /
    ///    / /\ \ |  ___/ | |   |  < |  __|   \   /
    ///   / ____ \| |    _| |_  | . \| |____   | |
    ///  /_/    \_\_|   |_____| |_|\_\______|  |_|
    
    private let APIKEY = "" // ⚠️ APIKEY IS Here
    
    /// ****************************************************
    
    func throwIfNoAPIKEY(file: StaticString = #filePath, line: UInt = #line) throws {
        if APIKEY.isEmpty {
            throw XCTSkip("Set API in the Helper column, ⚠️ remember don't commit it ⚠️ ", file: file, line: line)
        }
    }
    func remindIfAPIKEYShouldBeRemovedBeforeCommit(file: StaticString = #filePath, line: UInt = #line ) {
        if APIKEY.isEmpty {return}
        XCTFail("⚠️ Your API key is showing in a commited file, please remove before commit..", file: file, line: line)
    }
    
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
    
    private func getFontFileDataResult(file: StaticString = #file, line: UInt = #line) -> RemoteFontFileLoader.Outcome? {
        let url = abeezee_Font_From_gstatic_Wedsite
        let loader = RemoteFontFileLoader(client: ephemeralClient())
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RemoteFontFileLoader.Outcome?
        _ = loader.load(from: url) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private var theRealGoogleFontServerURL: URL {
        URL(string: "https://www.googleapis.com/webfonts/v1/webfonts?key=\(APIKEY)")!
    }
    
    private var abeezee_Font_From_gstatic_Wedsite: URL {
        URL(string: "http://fonts.gstatic.com/s/abeezee/v14/esDR31xSG-6AGleN6tKukbcHCpE.ttf")!
    }
    
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}
