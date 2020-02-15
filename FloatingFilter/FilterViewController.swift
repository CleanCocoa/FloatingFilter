//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class FilterViewController: NSViewController {
    @IBOutlet weak var filterTextField: NSTextField!

    var placeholderText: String? {
        didSet {
            guard isViewLoaded else { return }
            filterTextField.placeholderString = placeholderText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterTextField.placeholderString = self.placeholderText
    }
}
