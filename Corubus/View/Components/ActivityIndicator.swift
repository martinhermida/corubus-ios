import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    let color: UIColor?
    
    init(style: UIActivityIndicatorView.Style, color: UIColor?) {
        self.style = style
        self.color = color
    }

    init(style: UIActivityIndicatorView.Style) {
        self.style = style
        self.color = nil
    }
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        if let color = color {
            activityIndicator.color = color
        }
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}
