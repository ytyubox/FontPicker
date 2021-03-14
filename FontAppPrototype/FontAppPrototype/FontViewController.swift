//
/* 
 *		Created by 游宗諭 in 2021/3/14
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */



import UIKit
struct FontGroupViewModel {
    let fontName: String
    let fonts: [FontViewModel]
 }
struct FontViewModel {
    let name:String
    let font: UIFont?
}

class FontViewController: UITableViewController {
    let fontGroups = FontGroupViewModel.prototype
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        fontGroups.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : fontGroups[section - 1].fonts.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {return nil}
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.text = fontGroups[section - 1].fontName
        return label
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = """
                This a demo of Font picker
                all of these font are from `UIFont familyNames`
                No internet api was requested
                """
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath) as! FontCell
        let model = fontGroups[indexPath.section - 1].fonts[indexPath.row]
        cell.configure(name: model.name, font: model.font)
        return cell
    }
}



extension FontCell {
    func configure(name: String, font: UIFont?) {
        button.isHidden = true
        nameLabel.text = name
        fontLabel.font = font
        fontLabel.text = name

          fadeIn( font)
     }
 }
