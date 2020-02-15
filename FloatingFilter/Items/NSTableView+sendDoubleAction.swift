//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

extension NSTableView {
    /// Programmatically invoke the `doubleAction` on `target`, if possible.
    func sendDoubleAction() {
        guard let doubleAction = self.doubleAction else { return }
        NSApp.sendAction(doubleAction, to: target, from: self)
    }
}
