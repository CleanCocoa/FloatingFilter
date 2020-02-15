//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class FilterWindowController: NSWindowController {

    static let nibName: NSNib.Name = "FilterWindowController"

    @IBOutlet var filterViewController: FilterViewController!
    @IBOutlet var itemsViewController: ItemsViewController!

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

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
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

    func showItems(_ items: [Item]) {
        loadWindowIfNeeded()
        itemsViewController.showItems(items)
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
