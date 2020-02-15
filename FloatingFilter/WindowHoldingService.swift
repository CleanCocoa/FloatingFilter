//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

final class WindowHoldingService {
    var windowController: NSWindowController? {
        willSet {
            guard let existingWindow = windowController?.window else { return }
            NotificationCenter.default.removeObserver(
                self, name: NSWindow.willCloseNotification,
                object: existingWindow)
        }

        didSet {
            guard let windowController = windowController else { return }
            guard let window = windowController.window else {
                preconditionFailure("Window controller does not have a window to manage")
            }
            NotificationCenter.default.addObserver(
                self, selector: #selector(windowDidClose(_:)),
                name: NSWindow.willCloseNotification,
                object: window)
        }
    }

    func manage(windowController: NSWindowController) {
        self.windowController = windowController
    }

    @objc func windowDidClose(_ notification: Notification) {
        self.windowController = nil
    }
}

