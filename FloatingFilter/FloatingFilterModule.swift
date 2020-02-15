//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import func Foundation.NSLocalizedString

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public struct FloatingFilterModule {
    private init() { }

    public static func showFilterWindow(
        items: [Item],
        filterPlaceholderText: String = NSLocalizedString("Filter Items", comment: "Placeholder for the FloatingFilter text field")) {

        let windowController = FilterWindowController()
        windowController.configure(filterPlaceholderText: filterPlaceholderText)
        windowController.showWindow(nil)
        windowController.window?.center()
        windowController.window?.makeKeyAndOrderFront(nil)

        let interactor = FilterInteractor(view: windowController)
        interactor.showItems(items)

        windowController.filterChangeDelegate = interactor

        windowHoldingService.manage((windowController, interactor))
    }
}
