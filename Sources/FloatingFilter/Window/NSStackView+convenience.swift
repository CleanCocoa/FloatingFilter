import AppKit

// Dan Wood: "Preparing for SwiftUI in AppKit Code by Using NSStackViews Instead of Nib Files", 2022-08-24, <https://www.remotion.com/blog/preparing-for-swiftui-in-appkit-code-by-using-nsstackviews-instead-of-nib-files>
extension NSStackView {
    /// Use like `HStack`/`VStack` in SwiftUI.
    ///
    /// Example:
    ///
    ///     let iconAndTitleStackView = NSStackView(
    ///         distribution: .fill,
    ///         spacing: 8.0,
    ///         views: [bananaView, appleView, fooBarButton])
    convenience init(
        orientation: NSUserInterfaceLayoutOrientation = .horizontal,
        alignment: NSLayoutConstraint.Attribute? = nil, // default: center X/Y
        distribution: NSStackView.Distribution = .gravityAreas,
        spacing: CGFloat = 8.0,
        views: [NSView]? = nil
    ) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.orientation = orientation
        self.alignment = alignment ?? (orientation == .vertical ? .centerX : .centerY)
        self.distribution = distribution
        self.spacing = spacing
        if let views = views {
            for view in views {
                addView(view, in: .leading)
            }
        }
    }
}
