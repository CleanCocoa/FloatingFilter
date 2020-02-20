//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

protocol ItemSelectionDelegate: class {
    func itemsViewController(_ itemsViewController: ItemsViewController, didSelectItems selectedItems: [Item])
}

class ItemsViewController: NSViewController {
    fileprivate var items: [Item] = []

    weak var itemSelectionDelegate: ItemSelectionDelegate?

    @IBOutlet weak var tableView: NSTableView!

    func showItems(_ items: [Item]) {
        self.items = items
        self.tableView.reloadData()
    }

    /// Wired to `NSTableView.doubleAction` and thus also to `arrowKeyableTextFieldDidCommit`
    @IBAction func commitSelection(_ sender: NSTableView) {
        let selectedItems = items.enumerated()
            .filter { sender.selectedRowIndexes.contains($0.offset) }
            .map { $0.element }
        guard selectedItems.isNotEmpty else {
            NSSound.beep()
            return
        }
        itemSelectionDelegate?.itemsViewController(self, didSelectItems: selectedItems)
    }
}

extension ItemsViewController: NSTableViewDelegate, NSTableViewDataSource {
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

extension Collection {
    fileprivate var isNotEmpty: Bool {
        return self.isEmpty == false
    }
}
