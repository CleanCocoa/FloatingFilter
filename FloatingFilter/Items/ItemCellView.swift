//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class ItemCellView: NSTableCellView {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "ItemCell")

    func configure(item: Item) {
        self.imageView?.image = item.icon
        self.textField?.stringValue = item.title
    }
}
