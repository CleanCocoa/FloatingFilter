import AppKit

extension NSView {
    func addConstraintsToFillSuperview() {
        guard let superview = self.superview else { preconditionFailure("superview has to be set first") }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),

            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
