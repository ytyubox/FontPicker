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
	
	func test_didStartLoadingFontFileData_displaysLoadingFontFile() throws {
		let (sut, view) = makeSUT()
		let font = uniqueFont()
		
        sut.didStartLoadingData(for: (font, anyURL()))
		
		let message = try XCTUnwrap(view.messages.first)
		XCTAssertEqual(view.messages.count, 1)
        XCTAssertTrue(message.variants.compactMap(\.font).isEmpty)

	}
	
    func test_didFinishLoadingFontFileData_displaysRetryOnFailedFontFileTransformation() throws {
        let (sut, view) = makeSUT(fontTransformer: fail)
        let url1 = URL(string: "http://url1.com")!
        let url2 = URL(string: "http://url2.com")!
        let variants = [Variant(name: "v1", fileURL: url1), Variant(name: "v2", fileURL: url2)]
        let font = uniqueFont(variants: variants )
		
		sut.didFinishLoadingData(with: Data(), for: (font, url1))
		
        XCTAssertEqual(view.messages.count, 1)
        let message = try XCTUnwrap(view.messages.first)
        
        assertExpect(message, font, variants, shouldRetry: false, fonts: [nil, nil])
	}
	
	func test_didFinishLoadingFontFileData_displaysFontFileOnSuccessfulTransformation() throws {
		let transformedData = AnyFont()
        let (sut, view) = makeSUT(fontTransformer: { _ in transformedData })
		
        let url1 = URL(string: "http://url1.com")!
        let url2 = URL(string: "http://url2.com")!
        let variants = [Variant(name: "v1", fileURL: url1), Variant(name: "v2", fileURL: url2)]
        let font = uniqueFont(variants: variants )
        
        sut.didFinishLoadingData(with: Data(), for: (font, url1))
        
        let message1 = try XCTUnwrap(view.messages.first)
        XCTAssertEqual(view.messages.count, 1)
        assertExpect(message1, font, variants, shouldRetry: false, fonts: [transformedData, nil])
        
        sut.didFinishLoadingData(with: Data(), for: (font, url2))
        XCTAssertEqual(view.messages.count, 2)
        let message2 = view.messages[1]
        assertExpect(message2, font, variants, shouldRetry: false, fonts: [transformedData, transformedData])
	}
	
	func test_didFinishLoadingFontFileDataWithError_displaysRetry() throws {
        let font = uniqueFont()
        let (sut, view) = makeSUT()
		
		sut.didFinishLoadingData(with: anyNSError(), for: (font, anyURL()))
		
        let message = try XCTUnwrap(view.messages.first)
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertTrue(message.variants.compactMap(\.font).isEmpty)
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
	
    private func assertExpect(
        _ message: FontFileViewModel<FontFilePresenterTests.AnyFont>,
        _ font: Font,
        _ variants: [Variant],
        shouldRetry: Bool,
        fonts: [AnyFont?],
        file: StaticString = #filePath,
        line: UInt = #line
        
    ) {
        XCTAssertEqual(message.name, font.name)
        XCTAssertEqual(message.fontDemoText, "Demo")
        XCTAssertEqual(message.subsets, font.subsets)
        XCTAssertEqual(message.category, font.category)
        XCTAssertEqual(message.shouldRetry, shouldRetry)
        XCTAssertEqual(message.variants.map(\.weight), variants.map(\.name))
        XCTAssertEqual(message.variants.map(\.url), variants.map(\.fileURL))
        XCTAssertEqual(message.variants.map(\.font), fonts, file: file, line: line)
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
