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

        XCTRecord(snapshot: sut.snapshot(for: .init(style: .light)), named: "EMPTY_FONT_light")
        XCTRecord(snapshot: sut.snapshot(for: .init(style: .dark)), named: "EMPTY_FONT_dark")
    }

    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        XCTRecord(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_CONTENT_light")
        XCTRecord(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_CONTENT_dark")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        XCTRecord(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_ERROR_MESSAGE_light")
        XCTRecord(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_ERROR_MESSAGE_dark")
    }

    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        XCTRecord(snapshot: sut.snapshot(for: .init(style: .light)), named: "FONT_WITH_FAILED_IMAGE_LOADING_light")
        XCTRecord(snapshot: sut.snapshot(for: .init(style: .dark)), named: "FONT_WITH_FAILED_IMAGE_LOADING_dark")
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
            FontStub(name: "Font 1",
                      fontDemoText: "Demo",
                      variants: [
                        .init(font: .systemFont(ofSize: 12), weight: "regualr", url: anyURL(), shouldRetry: false),
                        .init(font: .systemFont(ofSize: 12), weight: "another weight", url: anyURL(), shouldRetry: false),
                      ],
                      subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                      fontDemoText: "Demo",
                      variants: [
                        .init(font: .systemFont(ofSize: 12), weight: "regualr", url: anyURL(), shouldRetry: false)
                      ],
                      subsets: ["subset 1", "subset 2"], category: "a Category"),
        ]
    }

    private func feedWithFailedImageLoading() -> [FontStub] {
        [
            FontStub(name: "Font 1",
                      fontDemoText: "Demo",
                      variants: [
                        .init(font: nil, weight: "regualr", url: anyURL(), shouldRetry: true),
                        .init(font: nil, weight: "another weight", url: anyURL(), shouldRetry: true),
                      ],
                      subsets: ["subset 1", "subset 2"], category: "a Category"),
            FontStub(name: "Font 2",
                      fontDemoText: "Demo",
                      variants: [
                        .init(font: nil, weight: "regualr", url: anyURL(), shouldRetry: true)
                      ],
                      subsets: ["subset 1", "subset 2"], category: "a Category"),
        ]
    }
}

private class FontStub: FontCellControllerDelegate {
    func requestLoad() {
        zip(controller, viewModel.variants)
            .forEach({ (controller, variant) in
            controller?.display(variant)
        })
    }

    func cancelLoad() {}

    let viewModel: FontFileViewModel<UIFont>
    var controller: [FontCellController?] = []

    init(name: String,
         fontDemoText: String,
         variants: [FontFileViewModel<UIFont>.VariantViewModel],
         subsets: [String],
         category: String) {
        viewModel = FontFileViewModel(
            name: name,
            fontDemoText: fontDemoText,
            variants: variants,
            subsets: subsets,
            category: category)
    }

    func didRequestImage() {
        zip(controller, viewModel.variants)
            .forEach({ (controller, variant) in
            controller?.display(variant)
        })
    }

    func didCancelImageRequest() {}
}

private extension FontViewController {
    func display(_ stubs: [FontStub]) {
        
        let groups: [FontGroupController] = stubs.map { stub in
            let cellControllers = stub.viewModel.variants.map{ _ in FontCellController(delegate: stub)}
            let group = FontGroupController(
                name: stub.viewModel.name,
                tableModel: cellControllers)
            stub.controller = cellControllers
            return group
        }
       
        
        display(groups)
    }
}
