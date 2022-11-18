//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class KeyPanel: NSPanel {
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
}

class FilterWindowController: NSWindowController {
    static let nibName: NSNib.Name = "FilterWindowController"

    @IBOutlet var visualEffectView: NSVisualEffectView!
    @IBOutlet var filterViewController: FilterViewController!
    @IBOutlet var itemsViewController: ItemsViewController!
    @IBOutlet var noResultsLabel: NSTextField!

    private var windowDidLoseFocusObserver: Any?

    convenience init() {
        self.init(windowNibName: FilterWindowController.nibName)
    }

    deinit {
        if let observer = windowDidLoseFocusObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        // Auto-close when deallocating the controller
        if window != nil {
            self.close()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let window = self.window else { assertionFailure(); return }

        // Make sure the window chrome is removed for the rounded corner effect to work properly.
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)
        window.backgroundColor = .clear

        visualEffectView.material = .popover // .popover is less translucent than .hudWindow and matches Spotlight
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 10
    }
}

// MARK: User Interface façade

extension FilterWindowController {
    private func loadWindowIfNeeded() {
        _ = self.window
    }

    func configure(filterPlaceholderText: String, windowLevel: NSWindow.Level, closeWhenLosingFocus: Bool) {
        loadWindowIfNeeded()

        filterViewController.placeholderText = filterPlaceholderText

        guard let window = self.window else { assertionFailure(); return }

        window.level = windowLevel

        self.windowDidLoseFocusObserver = NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: window, queue: nil) { notification in
            guard closeWhenLosingFocus else { return }
            guard let window = notification.object as? NSWindow else { return }
            window.close()
        }
    }

    var itemSelectionDelegate: ItemSelectionDelegate? {
        get {
            return itemsViewController?.itemSelectionDelegate
        }
        set {
            loadWindowIfNeeded()
            itemsViewController.itemSelectionDelegate = newValue
        }
    }

    var filterChangeDelegate: FilterChangeDelegate? {
        get {
            return filterViewController?.filterChangeDelegate
        }
        set {
            loadWindowIfNeeded()
            filterViewController.filterChangeDelegate = newValue
        }
    }
}

extension FilterWindowController: FilteredItemView {
    func showItems(_ items: [Item]) {
        loadWindowIfNeeded()
        itemsViewController.showItems(items)
        noResultsLabel.isHidden = !items.isEmpty
    }
}

// MARK: Close on ESC and other cancelation hotkeys

extension FilterWindowController {
    override func cancelOperation(_ sender: Any?) {
        self.close()
    }

    /// Is not part of `NSResponder` by default.
    @IBAction func cancel(_ sender: Any?) {
        self.close()
    }

    /// Declare ⌘W "Close" default handler.
    @IBAction func performClose(_ sender: Any?) {
        self.close()
    }
}

// MARK: Typing

extension FilterWindowController {
    override func insertText(_ insertString: Any) {
        self.filterViewController.insertText(insertString)
    }
}
