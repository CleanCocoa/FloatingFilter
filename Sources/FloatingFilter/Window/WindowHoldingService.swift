//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

final class WindowHoldingService {
    typealias Payload = (windowController: NSWindowController, disposable: Any)

    var payload: Payload? {
        willSet {
            guard let existingWindow = payload?.windowController.window else { return }
            NotificationCenter.default.removeObserver(
                self, name: NSWindow.willCloseNotification,
                object: existingWindow)
        }

        didSet {
            guard let payload = payload else { return }
            guard let window = payload.windowController.window else {
                preconditionFailure("Window controller does not have a window to manage")
            }
            NotificationCenter.default.addObserver(
                self, selector: #selector(windowDidClose(_:)),
                name: NSWindow.willCloseNotification,
                object: window)
        }
    }

    func manage(_ payload: Payload) {
        self.payload = payload
    }

    @objc func windowDidClose(_ notification: Notification) {
        self.payload = nil
    }
}

