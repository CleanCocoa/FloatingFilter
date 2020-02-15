//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import class AppKit.NSImage

/// A thing you can display in the floating filter window.
public struct Item {
    public let title: String
    public let icon: NSImage?

    public init(title: String, icon: NSImage?) {
        self.title = title
        self.icon = icon
    }
}
