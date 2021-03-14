//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import FontPickeriOS
import UIKit

extension FontCell {
    func simulateRetryAction() {
        retryButton.simulateTap()
    }

    var isShowingFont: Bool {
        return !fontLabel.isHidden
    }

    var isShowingLoadingIndicator: Bool {
        return fontContainer.isShimmering
    }

    var isShowingRetryAction: Bool {
        return !retryButton.isHidden
    }

    var nameText: String? {
        return nameLabel.text
    }

    var fontDemoText: String? {
        return fontLabel.text
    }

    var demoingFont: UIFont? {
        return fontLabel.font
    }
}
