import SwiftUI
import WebKit

// UIViewRepresentable to wrap WKWebView
struct GifWebView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifURL = URL(fileURLWithPath: gifPath)
            webView.loadFileURL(gifURL, allowingReadAccessTo: gifURL)
        } else {
            print("Error: GIF file not found in Bundle!")
        }

        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
