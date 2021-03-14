//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import Foundation
import LoadingSystem
import UIKit

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }

    private let stub: (URL) -> HTTPClient.Result

    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }

    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }

    static func onlineFont(
        transformer: @escaping (UIFont) -> Data,
        _ stub: @escaping (URL) -> (UIFont, HTTPURLResponse)
    ) -> HTTPClientStub {
        HTTPClientStub { url in
            let result = stub(url)
            let data = transformer(result.0)
            return .success((data, result.1))
        }
    }
}
