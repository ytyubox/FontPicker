//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import FontPickeriOS
import Foundation
import LoadingSystem
import UIKit
extension Loader {
    typealias Result = Outcome
}

extension FontUIIntegrationTests {
    class LoaderSpy: Loader {
        typealias Output = [Font]

        // MARK: - FontLoader

        private var feedRequests = [(Outcome) -> Void]()

        var loadFontCallCount: Int {
            return feedRequests.count
        }

        func load(completion: @escaping (Outcome) -> Void) {
            feedRequests.append(completion)
        }

        func completeFontLoading(with feed: [Font] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }

        func completeFontLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
    }

    class ImageLoaderSpy: CancellableLoader {
        typealias CancellableOutput = Data

        // MARK: - FontImageDataLoader

        private struct TaskSpy: CancellabelTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }

        private var imageRequests = [(url: URL, completion: (Outcome) -> Void)]()

        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }

        private(set) var cancelledImageURLs = [URL]()
        func load(from url: URL, completion: @escaping (Result<CancellableOutput, Error>) -> Void) -> CancellabelTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }

        func completeImageLoading(with font: UIFont = .defaultFont, at index: Int = 0) {
            let data = fontToData(font: font)
            imageRequests[index].completion(.success(data))
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}

extension UIFont {
    static let defaultFont = UIFont.systemFont(ofSize: 16)
}
