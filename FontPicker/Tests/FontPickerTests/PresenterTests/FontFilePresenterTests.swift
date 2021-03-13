//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import TestUtils
import LoadingSystem
import FontPicker

class FontFilePresenterTests: XCTestCase {
	
	func test_init_doesNotSendMessagesToView() {
		let (_, view) = makeSUT()
		
		XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
	}
	
	func test_didStartLoadingFontFileData_displaysLoadingFontFile() {
		let (sut, view) = makeSUT()
		let font = uniqueFont()
		
        sut.didStartLoadingImageData(for: font)
		
		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message?.font)

	}
	
	func test_didFinishLoadingFontFileData_displaysRetryOnFailedFontFileTransformation() {
        let (sut, view) = makeSUT(fontTransformer: fail)
		let font = uniqueFont()
		
		sut.didFinishLoadingImageData(with: Data(), for: font)
		
		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message?.font)
	}
	
	func test_didFinishLoadingFontFileData_displaysFontFileOnSuccessfulTransformation() {
		let font = uniqueFont()
		let transformedData = AnyFont()
        let (sut, view) = makeSUT(fontTransformer: { _ in transformedData })
		
        sut.didFinishLoadingImageData(with: Data(), for: font)
		
		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
        XCTAssertNotNil(message?.font)
	}
	
	func test_didFinishLoadingFontFileDataWithError_displaysRetry() {
        let font = uniqueFont()
        let (sut, view) = makeSUT()
		
		sut.didFinishLoadingImageData(with: anyNSError(), for: font)
		
		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
		XCTAssertNil(message?.font)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(
		fontTransformer: @escaping (Data) -> AnyFont? = { _ in nil },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: FontFilePresenter<ViewSpy, AnyFont>, view: ViewSpy) {
		let view = ViewSpy()
        let sut = FontFilePresenter(view: view, fontTransformer: fontTransformer)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}
	
	private var fail: (Data) -> AnyFont? {
		return { _ in nil }
	}
	
	private struct AnyFont: Equatable {}
	
    private class ViewSpy: FontFileView {
        typealias F = AnyFont
		
		private(set) var messages = [FontFileViewModel<AnyFont>]()
		
		func display(_ model: FontFileViewModel<AnyFont>) {
			messages.append(model)
		}
	}
	
}
