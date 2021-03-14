//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import UIKit

class IntroduceSectionController:NSObject, UITableViewDataSource, UITableViewDelegate, TableViewSource {
    convenience init(content: String) {
        self.init()
        self.content = content
    }
    var content:String? {
        set {
            cell.textLabel?.text = newValue
        }
        get {
            cell.textLabel?.text
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }
    
    
    private lazy var cell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell
    }
    
    
}
