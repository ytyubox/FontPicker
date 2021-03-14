//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import FontPicker
@testable import FontPickeriOS
import TestUtils
import UIKit
import XCTest

class FontSnapshotTests: XCTestCase {
    func test_emptyFont() throws {
        let sut = makeSUT()
        sut.display(emptyFont())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "EMPTY_FONT_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "EMPTY_FONT_dark")
    }

    func test_fontWithContent() {
        let sut = makeSUT()

        sut.display(fontWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_CONTENT_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_CONTENT_dark")
    }

    func test_fontWithExtraExtraExtraLargeContent() {
        let sut = makeSUT()

        sut.display(fontWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_light_extraExtraExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_dark_extraExtraExtraLarge")
    }

    func test_fontWithAccessibilityExtraLargeContent() {
        let sut = makeSUT()

        sut.display(fontWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .accessibilityExtraLarge)), named: "FONT_WITH_CONTENT_light_accessibilityExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .accessibilityExtraLarge)), named: "FONT_WITH_CONTENT_dark_accessibilityExtraLarge")
    }

    func test_fontWithAccessibilityExtraExtraExtraLargeContent() {
        let sut = makeSUT()

        sut.display(fontWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .accessibilityExtraExtraExtraLarge)), named: "FONT_WITH_CONTENT_light_accessibilityExtraExtraExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_dark_accessibilityExtraExtraExtraLarge")
    }

    func test_fontWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_ERROR_MESSAGE_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_ERROR_MESSAGE_dark")
    }

    func test_fontWithFailedFontFileLoading() {
        let sut = makeSUT()

        sut.display(fontWithFailedFontFileLoading())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_FAILED_IMAGE_LOADING_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_FAILED_IMAGE_LOADING_dark")
    }

    // MARK: Helpers

    private func makeSUT() -> FontViewController {
        let bundle = Bundle(for: FontViewController.self)
        let storyboard = UIStoryboard(name: "Font", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FontViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFont() -> [FontGroupController] {
        []
    }

    private func fontWithContent() -> [FontStub] {
        [
            FontStub(name: "A Really long Really long Really long Font 1",
                     fontDemoText: "A Really long Really long Really long Font 1",
                     variants: [
                        .init(font: .systemFont(ofSize: 12), weight: "A Really long Really long Really long name", shouldRetry: false, isLoading: false),
                        .init(font: .systemFont(ofSize: 12), weight: "another weight", shouldRetry: false, isLoading: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                     fontDemoText: "Demo",
                     variants: [
                        .init(font: .systemFont(ofSize: 12), weight: "regualr", shouldRetry: false, isLoading: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
        ]
    }

    private func fontWithFailedFontFileLoading() -> [FontStub] {
        [
            FontStub(name: "A Really long Really long Really long Font 1",
                     fontDemoText: "A Really long Really long Really long Font 1",
                     variants: [
                        .init(font: nil, weight: "A Really long Really long Really long name", shouldRetry: true, isLoading: false),
                        .init(font: nil, weight: "another weight", shouldRetry: true, isLoading: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                     fontDemoText: "Demo",
                     variants: [
                        .init(font: nil, weight: "regular", shouldRetry: true, isLoading: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
        ]
    }
}

private class FontStub: FontCellControllerDelegate {
    func requestLoad() {
        zip(controller, viewModel.variants)
            .forEach { controller, variant in
                controller?.display(variant)
            }
    }

    func cancelLoad() {}

    let viewModel: FontFileViewModel<UIFont>
    var controller: [FontCellController?] = []

    init(name: String,
         fontDemoText: String,
         variants: [FontFileViewModel<UIFont>.VariantViewModel],
         subsets: [String],
         category: String)
    {
        viewModel = FontFileViewModel(
            name: name,
            fontDemoText: fontDemoText,
            variants: variants,
            subsets: subsets,
            category: category
        )
    }

    func didRequestFontFile() {
        zip(controller, viewModel.variants)
            .forEach { controller, variant in
                controller?.display(variant)
            }
    }

    func didCancelFontFileRequest() {}
}

private extension FontViewController {
    func display(_ stubs: [FontStub]) {
        let groups: [FontGroupController] = stubs.map { stub in
            let cellControllers = stub.viewModel.variants.map { _ in FontCellController(delegate: stub) }
            let group = FontGroupController(
                name: stub.viewModel.name, demoText: stub.viewModel.fontDemoText,
                tableModel: cellControllers
            )
            stub.controller = cellControllers
            return group
        }

        display(groups)
    }
}
