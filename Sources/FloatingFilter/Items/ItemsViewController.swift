//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

protocol ItemSelectionDelegate: AnyObject {
    func itemsViewController(_ itemsViewController: ItemsViewController, didSelectItems selectedItems: [Item])
}

class ItemsViewController: NSViewController {
    fileprivate var items: [Item] = []

    weak var itemSelectionDelegate: ItemSelectionDelegate?

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var returnLabel: NSTextField!

    func showItems(_ items: [Item]) {
        self.items = items
        self.tableView.reloadData()
        showReturnLabelOnNonemptyFilter()
    }

    /// Wired to `NSTableView.doubleAction` and thus also to `arrowKeyableTextFieldDidCommit`
    @IBAction func commitSelection(_ sender: NSTableView) {
        let selectedItems = items.indexed()
            .filter { sender.selectedRowIndexes.contains($0.index) }
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

    func tableViewSelectionDidChange(_ notification: Notification) {
        showReturnLabelOnNonemptyFilter()
    }

    private func showReturnLabelOnNonemptyFilter() {
        returnLabel.isHidden = (tableView.selectedRow == -1)
    }

}

extension Collection {
    fileprivate var isNotEmpty: Bool {
        return self.isEmpty == false
    }
}
