//
/*
 *		Created by 游宗諭 in 2021/3/14
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import UIKit

public class IntroduceSectionController: NSObject, UITableViewDataSource, UITableViewDelegate, TableViewSource {
  


    public func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        nil
    }

    private lazy var cell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
    }()

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    public func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        cell
    }
    
    public func display(_ introduction: IntroctionViewModel) {
        cell.textLabel?.text = introduction.content
    }
}

public struct IntroctionViewModel {
    public let content:String
}
