

import FontPicker
import TestUtils
import XCTest

class FontPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(SUT.title, localized("FONT_VIEW_TITLE"))
    }

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFont_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoading()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true),
        ])
    }

    func test_didFinishLoadingFont_displaysFontAndStopsLoading() {
        let (sut, view) = makeSUT()
        let font = uniqueFonts().models

        sut.didFinishLoading(with: font)

        XCTAssertEqual(view.messages, [
            .display(font: font),
            .display(isLoading: false),
        ])
    }

    func test_didFinishLoadingFontWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()

        sut.didFinishLoading(with: anyNSError())

        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("FONT_VIEW_CONNECTION_ERROR")),
            .display(isLoading: false),
        ])
    }

    // MARK: - Helpers

    private typealias SUT = FontPresenter<ViewSpy>
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FontPresenter(fontView: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Font"
        let bundle = module // (for: SUT.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

    private class ViewSpy: FontView, FontLoadingView, FontErrorView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(font: [Font])
        }

        private(set) var messages = Set<Message>()

        func display(_ viewModel: FontErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }

        func display(_ viewModel: FontLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }

        func display(_ viewModel: FontViewModel) {
            messages.insert(.display(font: viewModel.items))
        }
    }
}
