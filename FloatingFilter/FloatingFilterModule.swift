//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public struct FloatingFilterModule {
    private init() { }

    public static func showFilterWindow() {
        let windowController = FilterWindowController()
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
        windowHoldingService.manage(windowController: windowController)
    }
}
