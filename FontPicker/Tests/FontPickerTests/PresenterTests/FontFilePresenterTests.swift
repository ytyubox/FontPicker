

import FontPicker
import LoadingSystem
import TestUtils
import XCTest

class FontFilePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFontFileData_displaysLoadingFontFile() throws {
        let (sut, view) = makeSUT()
        let variant = Variant(name: "any name", fileURL: anyURL())

        sut.didStartLoadingData(for: (variant, anyURL()))

        let message = try XCTUnwrap(view.messages.first)
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message.font)
    }

    func test_didFinishLoadingFontFileData_displaysRetryOnFailedFontFileTransformation() throws {
        let (sut, view) = makeSUT(fontTransformer: fail)
        let url1 = URL(string: "http://url1.com")!
        let variant = Variant(name: "v1", fileURL: url1)

        sut.didFinishLoadingData(with: Data(), for: (variant, url1))

        XCTAssertEqual(view.messages.count, 1)
        let message = try XCTUnwrap(view.messages.first)

        assertExpect(message, variant, shouldRetry: false, font: nil)
    }

    func test_didFinishLoadingFontFileData_displaysFontFileOnSuccessfulTransformation() throws {
        let transformedData = AnyFont()
        let (sut, view) = makeSUT(fontTransformer: { _ in transformedData })

        let url1 = URL(string: "http://url1.com")!
        let url2 = URL(string: "http://url2.com")!
        let variant1 = Variant(name: "v1", fileURL: url1)
        let variant2 = Variant(name: "v2", fileURL: url2)

        sut.didFinishLoadingData(with: Data(), for: (variant1, url1))

        let message1 = try XCTUnwrap(view.messages.first)
        XCTAssertEqual(view.messages.count, 1)
        assertExpect(message1, variant1, shouldRetry: false, font: transformedData)

        sut.didFinishLoadingData(with: Data(), for: (variant2, url2))
        XCTAssertEqual(view.messages.count, 2)
        let message2 = view.messages[1]
        assertExpect(message2, variant2, shouldRetry: false, font: transformedData)
    }

    func test_didFinishLoadingFontFileDataWithError_displaysRetry() throws {
        let variant = Variant(name: "any name", fileURL: anyURL())
        let (sut, view) = makeSUT()

        sut.didFinishLoadingData(with: anyNSError(), for: (variant, anyURL()))

        let message = try XCTUnwrap(view.messages.first)
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message.font)
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
        _ message: FontFileViewModel<FontFilePresenterTests.AnyFont>.VariantViewModel,
        _ variant: Variant,
        shouldRetry: Bool,
        font: AnyFont?,
        file: StaticString = #filePath,
        line: UInt = #line

    ) {
        XCTAssertEqual(message.shouldRetry, shouldRetry)
        XCTAssertEqual(message.weight, variant.name)
        XCTAssertEqual(message.url, variant.fileURL)
        XCTAssertEqual(message.font, font, file: file, line: line)
    }

    private var fail: (Data) -> AnyFont? {
        return { _ in nil }
    }

    private struct AnyFont: Equatable {}

    private class ViewSpy: FontFileView {
        typealias FONT = AnyFont

        private(set) var messages = [FontFileViewModel<AnyFont>.VariantViewModel]()

        func display(_ model: FontFileViewModel<AnyFont>.VariantViewModel) {
            messages.append(model)
        }
    }
}
