import AppKit

extension Bundle {
    static func current() -> Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: FilterWindowController.self)
        #endif
    }
}
