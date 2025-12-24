//
//  Global.swift
//  XString
//
//  Created by AeroStar on 16/12/2025.
//

internal import Combine
import SwiftUI
import WebKit

class Global: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @AppStorage("hasSeenQuickActionsDemo") var hasSeenQuickActionsDemo = false
}

final class WebViewStore: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var webView: WKWebView
    var onPageVisited: ((URL) -> Void)?
    var onStateChange: (() -> Void)?

    override init() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        self.webView.navigationDelegate = self
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.onPageVisited?(url)
            self.onStateChange?()
        }
    }
}



final class NYTNewsViewModel: NSObject, ObservableObject, XMLParserDelegate {
    @Published var latestHeadline: NewsHeadline?

    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = "" 
    private var didSetHeadline = false
    private var isInsideItem = false
    private let cache = NSCache<NSString, NewsHeadline>()
    private let cacheKey = "latestHeadline"

    func fetch() {
        if let cachedHeadline = cache.object(forKey: cacheKey as NSString) {
            self.latestHeadline = cachedHeadline
            return
        }

        guard let url = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }.resume()
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {

        currentElement = elementName

        if elementName == "item" {
            isInsideItem = true
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isInsideItem else { return }

        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        if elementName == "item" {
            DispatchQueue.main.async {
                let headline = NewsHeadline(
                    title: self.currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                    link: self.currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                    summary: self.currentDescription
                        .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                )
                self.cache.setObject(headline, forKey: self.cacheKey as NSString)
                self.latestHeadline = headline
            }
            parser.abortParsing()
        }
    }

}


class OnboardingViewVars: ObservableObject {
    @Published var image = ""
    @Published var isABrowsingDataModeSelected = false
    @Published var isAAccountModeSelected = false
}

enum FrameColor: String, CaseIterable, Identifiable {
    case silver, cosmicOrange, deepBlue
    var id: Self { self }
}

enum SelectedBrowsingDataMode: String, CaseIterable, Identifiable {
    case safari, opera, chromegoogle, none
    var id: Self { self }
}

enum SelectedAccountMode: String, CaseIterable, Identifiable {
    case signup, login, signedin, none
    var id: Self { self }
}

enum AIStage: String, CaseIterable, Identifiable {
    case request, stage1, stage2, none
    var id: Self { self }
}

extension Color {
    static let baseColors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .pink,
        .brown,
        .gray
    ]

    static func randomBase() -> Color {
        baseColors.randomElement()!
    }
}
