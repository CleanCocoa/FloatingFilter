//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import func Foundation.NSLocalizedString

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public typealias SelectionCallback = ([Item]) -> Void

public struct FloatingFilterModule {
    private init() { }

    public static func showFilterWindow(
        items: [Item],
        filterPlaceholderText: String = NSLocalizedString("Filter Items", comment: "Placeholder for the FloatingFilter text field"),
        selectionCallback: @escaping SelectionCallback) {

        let windowController = FilterWindowController()
        windowController.configure(filterPlaceholderText: filterPlaceholderText)
        windowController.showWindow(nil)
        windowController.window?.center()
        windowController.window?.makeKeyAndOrderFront(nil)

        let interactor = FilterInteractor(view: windowController)
        interactor.showItems(items)

        let callbackWrapper = CallbackWrapper(selectionCallback: selectionCallback)

        windowController.filterChangeDelegate = interactor
        windowController.itemSelectionDelegate = callbackWrapper

        windowHoldingService.manage((
            windowController: windowController,
            disposable: (interactor, callbackWrapper)))
    }
}

final class CallbackWrapper: ItemSelectionDelegate {
    let selectionCallback: SelectionCallback

    init(selectionCallback: @escaping SelectionCallback) {
        self.selectionCallback = selectionCallback
    }

    func itemsViewController(_ itemsViewController: ItemsViewController, didSelectItems selectedItems: [Item]) {
        self.selectionCallback(selectedItems)
    }
}
