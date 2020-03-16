//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class KeyPanel: NSPanel {
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
}

class FilterWindowController: NSWindowController {
    static let nibName: NSNib.Name = "FilterWindowController"

    @IBOutlet var filterViewController: FilterViewController!
    @IBOutlet var itemsViewController: ItemsViewController!
    @IBOutlet weak var noResultsLabel: NSTextField!

    convenience init() {
        self.init(windowNibName: FilterWindowController.nibName)
    }

    deinit {
        // Auto-close when deallocating the controller
        if window != nil {
            self.close()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let window = self.window else { assertionFailure(); return }
        window.isMovableByWindowBackground = true
    }
}

// MARK: User Interface façade

extension FilterWindowController {
    private func loadWindowIfNeeded() {
        _ = self.window
    }

    func configure(filterPlaceholderText: String) {
        loadWindowIfNeeded()
        filterViewController.placeholderText = filterPlaceholderText
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
}

// MARK: Typing

extension FilterWindowController {
    override func insertText(_ insertString: Any) {
        self.filterViewController.insertText(insertString)
    }
}
