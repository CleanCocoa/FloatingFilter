//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class ItemsViewController: NSViewController {
    fileprivate var items: [Item] = []

    var commitSelection: ((_ selectedItems: [Item]) -> Void)?
    var selectionChange: ((_ selectedItems: [Item]) -> Void)?

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var noResultsLabel: NSTextField!

    fileprivate func selectedItems() -> [Item] {
        items.indexed()
            .filter { tableView.selectedRowIndexes.contains($0.index) }
            .map { $0.element }
    }

    func showItems(_ items: [Item]) {
        self.items = items
        self.tableView.reloadData()
        self.selectionChange?(selectedItems())
        self.noResultsLabel.isHidden = !items.isEmpty
    }

    /// Wired to `NSTableView.doubleAction` and thus also to `arrowKeyableTextFieldDidCommit`
    @IBAction func commitSelection(_ sender: NSTableView) {
        let selectedItems = self.selectedItems()
        guard selectedItems.isNotEmpty else {
            NSSound.beep()
            return
        }
        self.commitSelection?(selectedItems)
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

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.selectionChange?(self.selectedItems())
    }
}

extension Collection {
    fileprivate var isNotEmpty: Bool {
        return self.isEmpty == false
    }
}
