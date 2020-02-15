//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import FloatingFilter

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FloatingFilterModule.showFilterWindow()
    }

    @IBAction func showPanel(_ sender: Any?) {
        FloatingFilterModule.showFilterWindow()
    }
}
