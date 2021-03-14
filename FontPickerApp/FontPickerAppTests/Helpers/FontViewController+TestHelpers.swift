//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPickeriOS
import UIKit

extension FontViewController {
    func simulateUserInitiatedFontReload() {
        refreshControl?.simulatePullToRefresh()
    }

    @discardableResult
    func simulateFontCellVisible(at index: Int) -> FontCell? {
        return feedImageView(at: index) as? FontCell
    }

    @discardableResult
    func simulateFontImageViewNotVisible(at row: Int) -> FontCell? {
        let view = simulateFontCellVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    func simulateFontImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateFontImageViewNotNearVisible(at row: Int) {
        simulateFontImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func renderedFontImageData(at index: Int) -> UIFont? {
        return simulateFontCellVisible(at: index)?.demoingFont
    }

    var errorMessage: String? {
        return errorView?.message
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func numberOfRenderedFontImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFontImageViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var feedImagesSection: Int {
        return 1
    }
}
