//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPicker
import FontPickeriOS
import XCTest

extension FontUIIntegrationTests {
    func assertThat(_ sut: FontViewController, isRendering feed: [Variant], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()

        guard sut.numberOfRenderedFontImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFontImageViews()) instead.", file: file, line: line)
        }

        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }

        executeRunLoopToCleanUpReferences()
    }

    func assertThat(_ sut: FontViewController, hasViewConfiguredFor variant: Variant, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? FontCell else {
            return XCTFail("Expected \(FontCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        //		let shouldLocationBeVisible = (variant.data != nil)
        //		XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.nameText, variant.name, "Expected location text to be \(String(describing: variant.name)) for image  view at index (\(index))", file: file, line: line)

//        XCTAssertEqual(cell.fontDemoText, , "Expected description text to be \(String(describing: variant.description)) for image view at index (\(index)", file: file, line: line)
    }

    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
