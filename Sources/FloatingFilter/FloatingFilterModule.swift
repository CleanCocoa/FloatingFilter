//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public typealias SelectionCallback = (_ selectedItems: [Item]) -> Void

public struct FloatingFilterModule {
    private init() { }

    public static func showFilterWindow(
        items: [Item],
        filterPlaceholderText: String = NSLocalizedString("Filter Items", comment: "Placeholder for the FloatingFilter text field"),
        windowLevel: NSWindow.Level = .floating,
        closeWhenLosingFocus: Bool = true,
        selection selectionCallback: @escaping SelectionCallback
    ) {
        let windowController = FilterWindowController()
        windowController.configure(
            filterPlaceholderText: filterPlaceholderText,
            windowLevel: windowLevel,
            closeWhenLosingFocus: closeWhenLosingFocus)
        windowController.showWindow(nil)

        if let window = windowController.window {
            // Offset a bit above center
            window.center()
            var newOrigin = window.frame.origin
            newOrigin.y -= (window.frame.height - 30) / 2
            window.setFrameOrigin(newOrigin)

            window.makeKeyAndOrderFront(nil)
        }

        let interactor = FilterInteractor(view: windowController)
        interactor.showItems(items)

        windowController.filterChangeDelegate = interactor
        windowController.commitSelection = { selectedItems in
            windowController.close()
            selectionCallback(selectedItems)
        }

        windowHoldingService.manage((
            windowController: windowController,
            disposable: interactor))
    }
}
