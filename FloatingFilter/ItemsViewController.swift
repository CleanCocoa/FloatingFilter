//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class ItemsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    fileprivate var items: [Item] = []

    @IBOutlet weak var tableView: NSTableView!

    func showItems(_ items: [Item]) {
        self.items = items
        self.tableView.reloadData()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return items[row]
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: ItemCellView.identifier, owner: self) as? ItemCellView
        cellView?.configure(item: items[row])
        return cellView
    }
}
