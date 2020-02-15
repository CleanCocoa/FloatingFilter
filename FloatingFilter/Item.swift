//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import class AppKit.NSImage

/// A thing you can display in the floating filter window.
///
/// The `identifier` property is not used by the module, but available for your convenience to identify
/// you app's true model items.
public struct Item {
    /// Identifier of the model object this represents.
    public let identifier: Any?

    public let title: String
    public let icon: NSImage?

    public init(identifier: Any? = nil, title: String, icon: NSImage?) {
        self.identifier = identifier
        self.title = title
        self.icon = icon
    }
}
