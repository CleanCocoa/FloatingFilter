//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public struct FloatingFilterModule {
    private init() { }

    public static func showFilterWindow(items: [Item]) {
        let windowController = FilterWindowController()
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
        windowHoldingService.manage(windowController: windowController)

        // Update views last when the window has been loaded
        windowController.showItems(items)
    }
}
