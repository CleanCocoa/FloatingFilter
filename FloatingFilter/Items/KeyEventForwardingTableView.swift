//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

/// `NSTableView` by defaults _edits_ a cell when you press the Enter key, but we want to forward this
/// as a selection confirmation.
class KeyEventForwardingTableView: NSTableView {
    override func keyDown(with event: NSEvent) {
        if let window = self.window {
            // Give up first responder status and let someone else handle this (which will be the text field)
            window.makeFirstResponder(window.initialFirstResponder)
            NSApp.sendEvent(event)
        } else {
            super.keyDown(with: event)
        }
    }

    override var mouseDownCanMoveWindow: Bool { true }
}
