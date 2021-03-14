//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
import LoadingSystem
import UIKit

protocol Logger {
    func trace(_ string: String)
}


class PrintLogger: Logger {
    func trace(_ string: String) {
        print(string)
    }
}

private class HTTPClientProfilingDecorator: HTTPClient {
    private let decoratee: HTTPClient
    private let logger: Logger
    
    init(decoratee: HTTPClient, logger: Logger) {
        self.decoratee = decoratee
        self.logger = logger
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        logger.trace("Started loading url: \(url.path)")
        
        let startTime = CACurrentMediaTime()
        return decoratee.get(from: url) { [logger] result in
            let elapsed = CACurrentMediaTime() - startTime
            if case let .failure(error) = result {
                logger.trace("Failure loading url: \(url.path) \t in \(elapsed) seconds, error: \(error.localizedDescription)")
            } else {
                logger.trace("Finished loading url: \(url.path) \t in \(elapsed) seconds")
            }
            completion(result)
        }
    }
}

extension HTTPClient {
    func log(with logger: Logger) -> HTTPClient {
        HTTPClientProfilingDecorator(decoratee: self, logger: logger)
    }
}
