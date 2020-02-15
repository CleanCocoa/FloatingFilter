//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class FilterWindowController: NSWindowController {

    static let nibName: NSNib.Name = "FilterWindowController"

    convenience init() {
        self.init(windowNibName: FilterWindowController.nibName)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
