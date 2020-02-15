//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

/// `NSTableView` by defaults _edits_ a cell when you press the Enter key, but we want to forward this
/// as a selection confirmation.
class KeyEventForwardingTableView: NSTableView {
    override func keyDown(with event: NSEvent) {
        if event.isEnter {
            sendDoubleAction()
        } else {
            super.keyDown(with: event)
        }
    }
}

fileprivate extension NSEvent {
    var isEnter: Bool {
        return self.keyCode == 0x24 // VK_RETURN
    }
}
