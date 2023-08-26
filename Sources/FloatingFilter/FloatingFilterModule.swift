//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

/// Used to manage an optional, auto-released window controller
private var windowHoldingService = WindowHoldingService()

public typealias SelectionCallback = (_ selectedItems: [Item]) -> Void
public typealias ItemFilter = (_ needle: String, _ haystack: [Item]) -> [Item]

public struct FloatingFilterModule {
    /// Uses the default filter that scores all ``Item``s by `pattern` fuzzily, discards matches below a certain
    /// threshold, and sorts by score.
    public static func defaultFuzzyFilter(
        fuzziness: Double = 0.3,
        threshold: Double = 0.4
    ) -> ItemFilter {
        return { needle, haystack in
            let needle = needle.localizedLowercase

            return haystack
                .map { (element: $0, score: $0.title.localizedLowercase.score(word: needle, fuzziness: fuzziness)) }
                .filter { $0.score > threshold }
                .sorted(by: { $0.score > $1.score })
                .map { $0.element }
        }
    }

    private init() { }

    /// - Parameters:
    ///   - items: Filter-able items, sorted, to show in the floating filter window.
    ///   - filterPlaceholderText: Placeholder for the FloatingFilter text field
    ///   - windowLevel: Level to show the filter window  on. Default `.floating` is intended for use
    ///     as a utility panel.
    ///   - closeWhenLosingFocus: Whether the filter should disappear when users e.g. activate another app
    ///     before completing the operation. Defaults to `true` to be used as a temporary utility.
    ///   - filter: Narrows down all filterable `items` to find `needle`. The default uses a fuzzy string
    ///     matching algorithm.
    ///   - selectionCallback: Output port for confirmed selections in the filter window.
    public static func showFilterWindow(
        items: [Item],
        filterPlaceholderText: String = NSLocalizedString("Filter Items", comment: "Placeholder for the FloatingFilter text field"),
        windowLevel: NSWindow.Level = .floating,
        closeWhenLosingFocus: Bool = true,
        filter: @escaping ItemFilter = FloatingFilterModule.defaultFuzzyFilter(),
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

        let interactor = FilterInteractor(
            view: windowController,
            filter: filter
        )
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
