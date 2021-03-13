/**
 * Created by 游宗諭 in 2020/12/14
 *
 *
 * Using Swift 5.0
 *
 * Running on macOS 10.15
 */

import UIKit

public final class FontFileCell: UITableViewCell {
    @IBOutlet public private(set) var locationContainer: UIView!
    @IBOutlet public private(set) var locationLabel: UILabel!
    @IBOutlet public private(set) var descriptionLabel: UILabel!
    @IBOutlet public private(set) var feedImageContainer: ShimmeringView!
    @IBOutlet public private(set) var feedImageView: UIImageView!
    @IBOutlet public private(set) var feedImageRetryButton: UIButton!
    var onRetry: (() -> Void)?
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        accessibilityIdentifier = "feed-image-cell"
        feedImageView.accessibilityIdentifier = "feed-image-view"
    }
}
