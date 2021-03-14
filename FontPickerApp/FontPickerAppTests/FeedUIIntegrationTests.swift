//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
@testable import FontPickerApp
import FontPickeriOS
import UIKit
import XCTest

final class FontUIIntegrationTests: XCTestCase {
    func test_feedView_hasTitle() {
        let (sut, _, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, localized("FEED_VIEW_TITLE"))
    }

    func test_loadFontActions_requestFontFromLoader() {
        let (sut, loader, _) = makeSUT()
        XCTAssertEqual(loader.loadFontCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFontCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedFontReload()
        XCTAssertEqual(loader.loadFontCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedFontReload()
        XCTAssertEqual(loader.loadFontCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingFontIndicator_isVisibleWhileLoadingFont() {
        let (sut, loader, _) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeFontLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedFontReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeFontLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    //	func test_loadFontCompletion_rendersSuccessfullyLoadedFont() {
    //		let image0 = makeImage(description: "a description", location: "a location")
    //		let image1 = makeImage(description: nil, location: "another location")
    //		let image2 = makeImage(description: "another description", location: nil)
    //		let image3 = makeImage(description: nil, location: nil)
    //		let (sut, loader, _) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		assertThat(sut, isRendering: [])
//
    //		loader.completeFontLoading(with: [image0], at: 0)
    //		assertThat(sut, isRendering: [image0])
//
    //		sut.simulateUserInitiatedFontReload()
    //		loader.completeFontLoading(with: [image0, image1, image2, image3], at: 1)
    //		assertThat(sut, isRendering: [image0, image1, image2, image3])
    //	}

    //	func test_loadFontCompletion_rendersSuccessfullyLoadedEmptyFontAfterNonEmptyFont() {
    //		let image0 = makeImage()
    //		let image1 = makeImage()
    //		let (sut, loader, _) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1], at: 0)
    //		assertThat(sut, isRendering: [image0, image1])
//
    //		sut.simulateUserInitiatedFontReload()
    //		loader.completeFontLoading(with: [], at: 1)
    //		assertThat(sut, isRendering: [])
    //	}

    //	func test_loadFontCompletion_doesNotAlterCurrentRenderingStateOnError() {
    //		let image0 = makeImage()
    //		let (sut, loader, _) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0], at: 0)
    //		assertThat(sut, isRendering: [image0])
//
    //		sut.simulateUserInitiatedFontReload()
    //		loader.completeFontLoadingWithError(at: 1)
    //		assertThat(sut, isRendering: [image0])
    //	}

    //	func test_loadFontCompletion_rendersErrorMessageOnErrorUntilNextReload() {
    //		let (sut, loader, _) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		XCTAssertEqual(sut.errorMessage, nil)
//
    //		loader.completeFontLoadingWithError(at: 0)
    //		XCTAssertEqual(sut.errorMessage, localized("FEED_VIEW_CONNECTION_ERROR"))
//
    //		sut.simulateUserInitiatedFontReload()
    //		XCTAssertEqual(sut.errorMessage, nil)
    //	}

    //	func test_feedImageView_loadsImageURLWhenVisible() {
    //		let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    //		let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    //		let (sut, loader, imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1])
//
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
//
    //		sut.simulateFontImageViewVisible(at: 0)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url], "Expected first image URL request once first view becomes visible")
//
    //		sut.simulateFontImageViewVisible(at: 1)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second view also becomes visible")
    //	}

    //	func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
    //		let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    //		let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    //		let (sut, loader, imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1])
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")
//
    //		sut.simulateFontImageViewNotVisible(at: 0)
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [image0.url], "Expected one cancelled image URL request once first image is not visible anymore")
//
    //		sut.simulateFontImageViewNotVisible(at: 1)
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [image0.url, image1.url], "Expected two cancelled image URL requests once second image is also not visible anymore")
    //	}

    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader, imageLoader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFontLoading(with: [makeFont(), makeFont()])

        let view0 = sut.simulateFontImageViewVisible(at: 0)
        let view1 = sut.simulateFontImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

        imageLoader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")

        imageLoader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")

        view1?.simulateRetryAction()
        XCTAssertEqual(view0?.isShowingLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, true, "Expected loading indicator state change for second view on retry action")
    }

    func test_feedImageView_rendersImageLoadedFromURL() {
        let (sut, loader, imageLoader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFontLoading(with: [makeFont(), makeFont()])

        let view0 = sut.simulateFontImageViewVisible(at: 0)
        let view1 = sut.simulateFontImageViewVisible(at: 1)
        XCTAssertEqual(view0?.demoingFont, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.demoingFont, .none, "Expected no image for second view while loading second image")

        let font0 = UIFont.systemFont(ofSize: 15)
        imageLoader.completeImageLoading(with: font0, at: 0)
        XCTAssertEqual(view0?.demoingFont, font0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.demoingFont, .none, "Expected no image state change for second view once first image loading completes successfully")

        let font1 = UIFont.systemFont(ofSize: 14)
        imageLoader.completeImageLoading(with: font1, at: 1)
        XCTAssertEqual(view0?.demoingFont, font0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.demoingFont, font1, "Expected image for second view once second image loading completes successfully")
    }

    func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
        let (sut, loader, imageLoader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFontLoading(with: [makeFont(), makeFont()])

        let view0 = sut.simulateFontImageViewVisible(at: 0)
        let view1 = sut.simulateFontImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

        let font = UIFont.systemFont(ofSize: 14)
        imageLoader.completeImageLoading(with: font, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        imageLoader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")

        view1?.simulateRetryAction()
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view on  second image retry")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view on retry")
    }

    //	func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
    //		let (sut, loader,imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [makeImage()])
//
    //		let view = sut.simulateFontImageViewVisible(at: 0)
    //		XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")
//
    //		let invalidImageData = Data("invalid image data".utf8)
    //		imageLoader.completeImageLoading(with: invalidImageData, at: 0)
    //		XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    //	}

    //	func test_feedImageViewRetryAction_retriesImageLoad() {
    //		let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    //		let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    //		let (sut, loader,imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1])
//
    //		let view0 = sut.simulateFontImageViewVisible(at: 0)
    //		let view1 = sut.simulateFontImageViewVisible(at: 1)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url], "Expected two image URL request for the two visible views")
//
    //		imageLoader.completeImageLoadingWithError(at: 0)
    //		imageLoader.completeImageLoadingWithError(at: 1)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url], "Expected only two image URL requests before retry action")
//
    //		view0?.simulateRetryAction()
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url, image0.url], "Expected third imageURL request after first view retry action")
//
    //		view1?.simulateRetryAction()
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url, image0.url, image1.url], "Expected fourth imageURL request after second view retry action")
    //	}

    //	func test_feedImageView_preloadsImageURLWhenNearVisible() {
    //		let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    //		let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    //		let (sut, loader,imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1])
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")
//
    //		sut.simulateFontImageViewNearVisible(at: 0)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url], "Expected first image URL request once first image is near visible")
//
    //		sut.simulateFontImageViewNearVisible(at: 1)
    //		XCTAssertEqual(imageLoader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second image is near visible")
    //	}

    //	func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
    //		let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    //		let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    //		let (sut, loader,imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [image0, image1])
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")
//
    //		sut.simulateFontImageViewNotNearVisible(at: 0)
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [image0.url], "Expected first cancelled image URL request once first image is not near visible anymore")
//
    //		sut.simulateFontImageViewNotNearVisible(at: 1)
    //		XCTAssertEqual(imageLoader.cancelledImageURLs, [image0.url, image1.url], "Expected second cancelled image URL request once second image is not near visible anymore")
    //	}

    //	func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
    //		let (sut, loader,imageLoader) = makeSUT()
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [makeImage()])
//
    //		let view = sut.simulateFontImageViewNotVisible(at: 0)
    //		imageLoader.completeImageLoading(with: anyImageData())
//
    //		XCTAssertNil(view?.demoingFont, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    //	}

    func test_loadFontCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeFontLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    //	func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
    //		let (sut, loader,imageLoader) = makeSUT()
//
    //		sut.loadViewIfNeeded()
    //		loader.completeFontLoading(with: [makeImage()])
    //		_ = sut.simulateFontImageViewVisible(at: 0)
//
    //		let exp = expectation(description: "Wait for background queue")
    //		DispatchQueue.global().async {
    //			imageLoader.completeImageLoading(with: self.anyImageData(), at: 0)
    //			exp.fulfill()
    //		}
    //		wait(for: [exp], timeout: 1.0)
    //	}

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FontViewController, loader: LoaderSpy, imageLoader: ImageLoaderSpy) {
        let loader = LoaderSpy()
        let imageLoader = ImageLoaderSpy()
        let sut = FontUIComposer.fontComposedWith(
            fontLoader: loader.toAnyLoader(),
            fontFileLoader: imageLoader.toAnyCancellableLoader()
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(imageLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader, imageLoader)
    }

    private func makeFont(description _: String? = nil, location _: String? = nil, url _: URL = URL(string: "http://any-url.com")!) -> Font {
        return uniqueFont()
    }

    private func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
}
