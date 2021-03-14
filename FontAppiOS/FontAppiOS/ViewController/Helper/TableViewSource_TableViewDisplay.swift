//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import UIKit

protocol TableViewSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
}

protocol TableViewDisplay {
    func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt indexPath: IndexPath)

    func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath])

    func tableView(_: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath])
}
