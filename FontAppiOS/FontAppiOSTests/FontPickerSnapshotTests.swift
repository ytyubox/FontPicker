//
/*
 *		Created by 游宗諭 in 2021/3/13
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

@testable import FontAppiOS
import FontPicker
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

    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_CONTENT_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_CONTENT_dark")
    }

    func test_feedWithExtraExtraExtraLargeContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_light_extraExtraExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_dark_extraExtraExtraLarge")
    }

    func test_feedWithAccessibilityExtraLargeContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .accessibilityExtraLarge)), named: "FONT_WITH_CONTENT_light_accessibilityExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .accessibilityExtraLarge)), named: "FONT_WITH_CONTENT_dark_accessibilityExtraLarge")
    }

    func test_feedWithAccessibilityExtraExtraExtraLargeContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light, contentSize: .accessibilityExtraExtraExtraLarge)), named: "FONT_WITH_CONTENT_light_accessibilityExtraExtraExtraLarge")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FONT_WITH_CONTENT_dark_accessibilityExtraExtraExtraLarge")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        XCTAssert(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_ERROR_MESSAGE_light")
        XCTAssert(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_ERROR_MESSAGE_dark")
    }

    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

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

    private func feedWithContent() -> [FontStub] {
        [
            FontStub(name: "A Really long Really long Really long Font 1",
                     fontDemoText: "A Really long Really long Really long Font 1",
                     variants: [
                         .init(font: .systemFont(ofSize: 12), weight: "A Really long Really long Really long name", url: anyURL(), shouldRetry: false),
                         .init(font: .systemFont(ofSize: 12), weight: "another weight", url: anyURL(), shouldRetry: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                     fontDemoText: "Demo",
                     variants: [
                         .init(font: .systemFont(ofSize: 12), weight: "regualr", url: anyURL(), shouldRetry: false),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
        ]
    }

    private func feedWithFailedImageLoading() -> [FontStub] {
        [
            FontStub(name: "A Really long Really long Really long Font 1",
                     fontDemoText: "A Really long Really long Really long Font 1",
                     variants: [
                         .init(font: nil, weight: "A Really long Really long Really long name", url: anyURL(), shouldRetry: true),
                         .init(font: nil, weight: "another weight", url: anyURL(), shouldRetry: true),
                     ],
                     subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                     fontDemoText: "Demo",
                     variants: [
                         .init(font: nil, weight: "regular", url: anyURL(), shouldRetry: true),
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

    func didRequestImage() {
        zip(controller, viewModel.variants)
            .forEach { controller, variant in
                controller?.display(variant)
            }
    }

    func didCancelImageRequest() {}
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
