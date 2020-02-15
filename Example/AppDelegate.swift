//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import FloatingFilter

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let items = [
        Item(title: "You", icon: NSImage(named: NSImage.userName)),
        Item(title: "Really", icon: NSImage(named: NSImage.preferencesGeneralName)),
        Item(title: "Rock", icon: NSImage(named: NSImage.folderName))
    ]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        showPanel(nil)
    }

    @IBAction func showPanel(_ sender: Any?) {
        FloatingFilterModule.showFilterWindow(items: items) { items in
            print(items.map { $0.title })
        }
    }
}
