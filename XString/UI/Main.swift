//
//  Main.swift
//  XString
//
//  Created by AeroStar on 19/12/2025.
//

import SwiftUI
import WebKit
import AppwriteModels
internal import Combine


struct Main: View {
    var currentTabIndex: Int {
        tabs.firstIndex { $0.id == selectedTabID }!
    }
    var currentTab: BrowserTab {
        tabs[currentTabIndex]
    }
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    @EnvironmentObject var viewmodel: ViewModel
    @EnvironmentObject var sharedText: UserAuthModel
    @EnvironmentObject var global: Global
    @ObservedObject var vm = AssistantViewModel()
    @StateObject private var taskDetails = TaskDetails()
    @State private var currentURL: URL?
    @State private var webView = WKWebView()
    @StateObject private var webViewStore = WebViewStore()
    @State private var isUserNavigation = false
    @State private var history: [HistoryItem] = []
    @State private var showHistory = false
    @State private var showSettings = false
    @State private var showTabs = false
    @State private var showProfile = false
    @State private var moreInfo = false
    @StateObject private var nty = NYTNewsViewModel()
    @State private var tabs: [BrowserTab]
    @State private var selectedTabID: UUID
    @Namespace var namespace
    @State private var showAssistant = false
    init() {
        let firstTab = BrowserTab(store: WebViewStore())
        _tabs = State(initialValue: [firstTab])
        _selectedTabID = State(initialValue: firstTab.id)
    }
    var canGoBack: Bool {
        currentTab.store.webView.canGoBack
    }

    var canGoForward: Bool {
        currentTab.store.webView.canGoForward
    }

    func goBack() {
        currentTab.store.webView.goBack()
    }

    func goForward() {
        currentTab.store.webView.goForward()
    }
    var body: some View {
        VStack {
            if currentTab.submitted {
                WebView(store: currentTab.store)
                    .id(currentTab.id)
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        TitleBar()
                    }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: Header
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Welcome")
                                    .fontWidth(.expanded)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                
                                if let name = viewmodel.currentUser?.name, !name.isEmpty {
                                    Text(name)
                                        .font(.system(size: 25, weight: .heavy, design: .default))
                                        .fontDesign(.rounded)
                                        .opacity(0.8)
                                }
                            }
                            Spacer()
                            Button {
                                showProfile.toggle()
                            } label: {
                                Image(systemName: "person.fill")
                                    .padding(10)
                            }
                            .glassEffect(.regular.interactive())
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gear")
                                    .padding(10)
                            }
                            .glassEffect(.regular.interactive())
                        }
                        .padding(.horizontal)

                        // MARK: Quick Actions Card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "sparkles.square.filled.on.square")
                                    .font(.title2)
                                    .foregroundStyle(Color.purple.gradient)
                                Text("Quick Actions")
                                    .font(.title2.bold())
                                Spacer()
                                Button {
                                    moreInfo.toggle()
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                                .foregroundStyle(.blue)
                            }

                            Text("Easily access powerful features from the home menu.")
                                .font(.subheadline)
                                .opacity(0.7)
                        }
                        .foregroundStyle(.black)
                        .padding()
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal)
                        .popover(isPresented: $moreInfo, arrowEdge: .bottom) {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("Quick Actions")
                                        .bold()
                                    Spacer()
                                    Button {
                                        moreInfo.toggle()
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                    .foregroundStyle(.blue)
                                }
                                .padding(.bottom, 10)
                                Text("Quick Actions are a way to easily access \nfunctions from the home menu.")
                                    .multilineTextAlignment(.center)
                            }
                            .presentationCompactAdaptation(.popover)
                            .padding()
                        }
                        
                        NavigationLink("", destination: Main(), isActive: $showSettings)
                            .hidden()

                        // MARK: News Card
                        VStack {
                            HStack {
                                Text("Latest News")
                                    .font(.headline)
                                    .bold()
                                    .foregroundStyle(.pink.gradient)
                                Spacer()
                            }
                            .padding([.horizontal, .top])
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Group {
                                    if let headline = nty.latestHeadline {
                                        Text("New York Times")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .fontDesign(.serif)
                                        Text(headline.title)
                                            .font(.headline)
                                            .lineLimit(2)
                                        
                                        if !headline.description.isEmpty {
                                            Text(headline.description)
                                                .font(.subheadline)
                                                .opacity(0.75)
                                        }
                                    } else {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("New York Times")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .fontDesign(.serif)
                                            Text("Fetching the latest headline for you right now...")
                                                .font(.headline)
                                        }
                                        .redacted(reason: .placeholder)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            HStack {
                                Text("Read it all")
                                Image(systemName: "chevron.right")
                                Spacer()
                            }
                            .foregroundStyle(.blue)
                            .padding([.horizontal, .bottom])

                        }
                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard
                                let headline = nty.latestHeadline,
                                let url = URL(string: headline.link)
                            else { return }
                            
                            currentTab.store.webView.load(URLRequest(url: url))
                            tabs[currentTabIndex].searchText = url.absoluteString
                            withAnimation(.easeInOut(duration: 0.3)) {
                                tabs[currentTabIndex].submitted = true
                            }
                        }
                    }
                    .padding(.top)
                }
                .transition(.opacity)
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showHistory) {
            NavigationView {
                HistoryView(history: history) { item in
                    showHistory = false
                    webViewStore.webView.load(
                        URLRequest(url: URL(string: item.url)!)
                    )
                }
            }
        }
        .sheet(isPresented: $showAssistant) {
            AssistantPanel(vm: vm, onGenerateAI: {
                Task {
                    let groq = GroqClient()
                    let text = taskDetails.taskName

                    let messages = [
                        GroqMessage(
                            role: "system",
                            content: """
                            The user is requesting you generate a medium length description of a task for them.
                            Inculde only the task descriptio
                            String of text:
                            \(text)
                            """
                        )
                    ]

                    do {
                        let reply = try await groq.chat(messages: messages)
                        print("Groq reply:", reply)
                        taskDetails.taskDetails = reply
                    } catch {
                        print("Groq error:", error)
                    }
                }
            })
            .environmentObject(taskDetails)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showTabs) {
            TabsView(
                tabs: tabs,
                selectedTabID: selectedTabID,
                onSelect: { tab in
                    selectedTabID = tab.id
                    showTabs = false
                },
                onClose: { tab in
                    closeTab(tab)
                },
                onNewTab: {
                    newTab()
                    showTabs = false
                }
            )
        }
        .onAppear {
            attachHistoryListener()
        }
        .onChange(of: selectedTabID) { _ in
            attachHistoryListener()
        }
        .overlay(alignment: .bottom) {
            SearchBar(
                text: $tabs[currentTabIndex].searchText, vm: vm,
                canGoBack: currentTab.canGoBack,
                canGoForward: currentTab.canGoForward,
                onBack: { _ in
                    currentTab.store.webView.goBack()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        syncURLToSearchBar()
                    }
                },
                onForward: { _ in
                    currentTab.store.webView.goForward()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        syncURLToSearchBar()
                    }
                },
                onSubmit: {_ in
                    tabs[currentTabIndex].inputText = tabs[currentTabIndex].searchText
                    if let url = resolveInputToURL(tabs[currentTabIndex].searchText) {
                        currentTab.store.webView.load(URLRequest(url: url))
                        
                        tabs[currentTabIndex].searchText = url.absoluteString
                    }
                    Task {
                        let groq = GroqClient()

                        let text = tabs[currentTabIndex].inputText

                        let messages = [
                            GroqMessage(
                                role: "system",
                                content: """
                The user has searched a string of text.
                Please check if it is relevant to:
                - Cooking
                - Shopping
                - Travel planning (hotels, nice areas, flights, booking tickets for something like a football match does not count)
                - be very strict on how relevant they are.

                If relevant, reply ONLY with:
                aJb3&hB12

                If not relevant, reply with nothing.

                String of text:
                \(text)
                """
                            )
                        ]

                        do {
                            let reply = try await groq.chat(messages: messages)

                            print("Groq reply:", reply)

                            // ✅ THIS is how you check it
                            if reply.contains("aJb3&hB12") {
                                showAssistant = true
                                vm.start(for: tabs[currentTabIndex])
                            }
                        } catch {
                            print("Groq error:", error)
                        }
                    }
                },
                onHistory: {
                    showHistory = true
                },
                onAI: {
                    vm.start(for: currentTab)
                    showAssistant = true
                }, onTabs: {
                    snapshotAllTabs()
                    showTabs.toggle()
                }
            )
            .padding(.trailing)
            .padding(.leading)
            .onSubmit {
                if !tabs[currentTabIndex].searchText.isEmpty {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        tabs[currentTabIndex].submitted = true
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        tabs[currentTabIndex].submitted = false
                    }
                }
            }
        }
        .onChange(of: selectedTabID) { newID in
            syncNavigationState(for: newID)
        }
        .onAppear {
            onboardingVars.image = "9"
            nty.fetch()
            
            currentTab.store.onStateChange = {
                tabs[currentTabIndex].canGoBack = currentTab.store.webView.canGoBack
                tabs[currentTabIndex].canGoForward = currentTab.store.webView.canGoForward
                tabs[currentTabIndex].title = currentTab.store.webView.title ?? ""
            }
        }
        .background(
            Image(onboardingVars.image)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
    }
    func syncURLToSearchBar() {
        if let url = webViewStore.webView.url {
            tabs[currentTabIndex].searchText = url.absoluteString
        }
    }
    func newTab() {
        let store = WebViewStore()
        let tab = BrowserTab(store: store)

        store.onStateChange = { [weak store] in
            guard let store else { return }

            if let index = tabs.firstIndex(where: { $0.store === store }) {
                tabs[index].canGoBack = store.webView.canGoBack
                tabs[index].canGoForward = store.webView.canGoForward
                tabs[index].title = store.webView.title ?? ""
            }
        }

        tabs.append(tab)
        selectedTabID = tab.id
    }

    func closeTab(_ tab: BrowserTab) {
        tabs.removeAll { $0.id == tab.id }

        if tabs.isEmpty {
            newTab()
        } else {
            selectedTabID = tabs.last!.id
        }
    }
    func snapshotAllTabs() {
        for index in tabs.indices {
            let webView = tabs[index].store.webView
            let config = WKSnapshotConfiguration()

            webView.takeSnapshot(with: config) { image, _ in
                if let image {
                    tabs[index].snapshot = image
                }
            }
        }
    }
    func syncNavigationState(for tabID: UUID) {
        guard let index = tabs.firstIndex(where: { $0.id == tabID }) else { return }

        let webView = tabs[index].store.webView
        tabs[index].canGoBack = webView.canGoBack
        tabs[index].canGoForward = webView.canGoForward
    }
    func attachHistoryListener() {
        currentTab.store.onPageVisited = { url in
            let entry = HistoryItem(url: url.absoluteString, date: Date())

            // Prevent duplicates in a row
            if history.last?.url != entry.url {
                history.append(entry)
            }

            tabs[currentTabIndex].searchText = entry.url
        }
    }

}

struct TitleBar: View {
    var body: some View {
        HStack {
            Text("wsg")
        }
        .background(.ultraThinMaterial)
    }
}

struct SearchBar: View {
    @Binding var text: String
    @ObservedObject var vm: AssistantViewModel
    let canGoBack: Bool
    let canGoForward: Bool
    let onBack: (String) -> Void
    let onForward: (String) -> Void
    let onSubmit: (String) -> Void
    let onHistory: () -> Void
    let onAI: () -> Void
    let onTabs: () -> Void
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                
                Button {
                    onBack(text)
                } label: {
                    Image(systemName: "chevron.left")
                }
                .disabled(!canGoBack)
                .opacity(canGoBack ? 1 : 0.3)
                
                Button {
                    onForward(text)
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward)
                .opacity(canGoForward ? 1 : 0.3)
                
                TextField("Search or enter website", text: $text)
                    .submitLabel(.go)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        onSubmit(text)
                    }
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .glassEffect()
                Menu {
                    Button("History") {
                        onHistory()
                    }
                    Button("Tabs") {
                        onTabs()
                    }
                    
                    Button {
                        onAI()
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                                .imageScale(.medium)
                            Text("AI Assistant")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding()
                        .glassEffect(.regular.interactive())
                }
            

        }
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var store: WebViewStore

    func makeUIView(context: Context) -> WKWebView {
        store.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Intentionally empty
    }
}


struct HistoryItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let url: String
    let date: Date
}

struct TaskIdea: Identifiable, Codable, Equatable {
    var id = UUID()
    var ideaName: String = ""
    var ideaLink: String = ""
    var ideaDesc: String = ""
}

class NewsHeadline: NSObject, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let summary: String

    init(title: String, link: String, summary: String) {
        self.title = title
        self.link = link
        self.summary = summary
    }
}

struct BrowserTab: Identifiable {
    let id = UUID()
    let store: WebViewStore

    // UI / state
    var searchText: String = ""
    var submitted: Bool = false
    var inputText: String = ""

    // Navigation state
    var canGoBack: Bool = false
    var canGoForward: Bool = false

    // Optional (for TabsView)
    var title: String = ""
    var snapshot: UIImage? = nil
}

struct TabsView: View {
    let tabs: [BrowserTab]
    let selectedTabID: UUID
    let onSelect: (BrowserTab) -> Void
    let onClose: (BrowserTab) -> Void
    let onNewTab: () -> Void
    var text = "Tab"

    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
            ZStack {
                ScrollView {
                    Text("Tabs")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    Text("Number of tabs: \(tabs.count)")
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(tabs) { tab in
                            VStack(spacing: 8) {
                                TabPreview(tab: tab)
                                    .frame(minWidth: 160) // ensures width is predictable
                                    .background(RoundedRectangle(cornerRadius: 14).fill(.gray.opacity(0.25)))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(
                                                tab.id == selectedTabID ? .blue : .clear,
                                                lineWidth: 2
                                            )
                                        
                                    )
                                    .onTapGesture {
                                        onSelect(tab)
                                    }
                                    .frame(height: 220)
                                HStack {
                                    Text(text)
                                        .font(.caption)
                                        .lineLimit(1)
                                    Spacer()
                                    
                                    Button {
                                        onClose(tab)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                    .disabled(tabs.count == 1)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    Button(action: onNewTab) {
                        Label("New Tab", systemImage: "plus")
                            .padding()
                            .glassEffect(.regular.interactive())
                    }
                    .padding(.bottom, 20)
                }
            }
    }
}

struct TabPreview: View {
    let tab: BrowserTab

    var body: some View {
        Group {
            if let image = tab.snapshot {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
            }
        }
        .frame(height: 220)
        .cornerRadius(14)
        .clipped()
    }
}



struct HistoryView: View {
    let history: [HistoryItem]
    let onSelect: (HistoryItem) -> Void

    var body: some View {
        List {
            ForEach(groupedHistory.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(sectionTitle(for: date))) {
                    ForEach(groupedHistory[date]!.reversed()) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.url)
                                    .font(.body)
                                    .lineLimit(1)

                                Text(item.date, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("History")
    }

    private var groupedHistory: [Date: [HistoryItem]] {
        Dictionary(grouping: history) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }

    private func sectionTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    @EnvironmentObject var viewmodel: ViewModel
    @EnvironmentObject var sharedText: UserAuthModel
    @EnvironmentObject var global: Global
    @State private var selectedColor: Color = Color.randomBase()
    var placeholder: String = "Enter details…"
    var body: some View {
        VStack(spacing: 15) {
            Text("Profile")
                .font(.largeTitle)
                .bold()
                .padding()
            HStack(spacing: 25) {
                Text(firstLetter)
                    .font(.system(size: 85))
                    .bold()
                    .background(
                        Circle()
                            .foregroundStyle(selectedColor.gradient)
                            .frame(width: 140, height: 140)
                    )
                    .padding()
                VStack(alignment: .leading) {
                    Text(viewmodel.currentUser?.name ?? "User")
                        .bold()
                        .font(.title2)
                    Text(viewmodel.currentUser?.email ?? "User@example.com")
                }
            }
            Spacer()
            Group {
                VStack(alignment: .leading, spacing: 7.5) {
                    Text("Date User Created:")
                        .bold()
                        .font(.title3)
                    Text(viewmodel.currentUser?.createdAt ?? "nil")
                    Text("Last Login Date:")
                        .bold()
                        .font(.title3)
                    Text(viewmodel.currentUser?.accessedAt ?? "nil")
                    Text("Friends:")
                    
                }
                .padding()
            }
            .glassEffect(.regular.interactive().tint(selectedColor.opacity(0.25)), in: RoundedRectangle(cornerRadius: 30))
            Spacer()
            Text("Made by Aero Studios")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.6))
        }
        .foregroundStyle(.black)
    }

    private var firstLetter: String {
        guard let name = viewmodel.currentUser?.name, !name.isEmpty else { return "U" }
        return String(name.first!)
    }
}

class TaskDetails: ObservableObject {
    @Published var taskID = UUID.self
    @Published var taskName = ""
    @Published var taskDetails = ""
}

struct AssistantPanel: View {
    @ObservedObject var vm: AssistantViewModel
    @State private var aistage: AIStage = .request
    @EnvironmentObject var taskDetails: TaskDetails
    @State private var selectedColor: Color = Color.randomBase()
    var placeholder: String = "Enter details…"
    let onGenerateAI: () -> Void
    var body: some View {
        VStack {
            if aistage == .request {
                VStack(spacing: 12) {
                    Text("Hey! I Can help with this!")
                        .font(.title)
                        .bold()
                        .padding(.top, 30)
                    Text("AI is in beta, responses may not be accurate.")
                        .font(.callout)
                        .opacity(0.5)
                    HStack {
                        Button {
                            aistage = .stage1
                        } label: {
                            HStack {
                                Spacer()
                                Text("Sure!")
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                        }
                        .buttonStyle(.glassProminent)
                        Button {
                            aistage = .none
                        } label: {
                            HStack {
                                Spacer()
                                Text("No thanks.")
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                        }
                        .buttonStyle(.glassProminent)
                    }
                }
                .padding()
            }
            if aistage == .stage1 {
                Text("Task Info")
                    .font(.title)
                    .bold()
                ZStack(alignment: .topLeading) {
                    // Background card
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                    
                    TextField("Name of task", text: $taskDetails.taskName)
                        .padding(8)
                        .background(Color.clear)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .frame(width: 350, height: 35)
                    Text("Task Details")
                ZStack(alignment: .topLeading) {
                    // Background card
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))

                    // Actual editor
                    TextEditor(text: $taskDetails.taskDetails)
                        .padding(8)
                        .scrollContentBackground(.hidden)   // iOS 16+
                        .background(Color.clear)
                }
                .frame(width: 350, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .overlay(alignment: .bottomLeading) {
                    Button {
                        onGenerateAI()
                    } label: {
                        Text("Generate withAI")
                            .font(.callout)
                            .opacity(0.75)
                    }
                    .disabled(taskDetails.taskName.isEmpty)
                    .foregroundStyle(.white)
                    .buttonStyle(.glassProminent)
                    .padding(8)
                }
                
            }
            if aistage == .stage2 {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(vm.messages.filter { shouldDisplay($0) }) { msg in
                            Text(msg.content)
                                .padding()
                                .background(
                                    msg.role == "assistant"
                                    ? Color.blue.opacity(0.2)
                                    : Color.gray.opacity(0.2)
                                )
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Ask the assistant.", text: $vm.input)
                        .onSubmit {
                            Task { await vm.send() }
                        }
                        .disabled(vm.isLoading)
                    
                    Button {
                        Task { await vm.send() }
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(vm.isLoading)
                    .disabled(vm.input.isEmpty)
                    .padding(7.5)
                    .glassEffect(.regular.tint(.blue))
                }
                .padding(10)
                .glassEffect()
                .padding()
            }
        }
        .padding(.leading.union(.trailing))
        .foregroundStyle(.black)
        .presentationDetents([.medium, .large])
    }
}


// MARK: funcs

func shouldDisplay(_ message: GroqMessage) -> Bool {
    // Hide system messages
    if message.role == "system" { return false }

    // Hide initial context injection
    if message.content.hasPrefix("Current page:") {
        return false
    }

    return true
}

func urlFromInput(_ input: String) -> URL? {
    if let url = URL(string: input), url.scheme != nil {
        return url
    }

    if let url = URL(string: "https://\(input)") {
        return url
    }

    let query = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    return URL(string: "https://www.google.com/search?q=\(query)")
}

func resolveInputToURL(_ input: String) -> URL? {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

    // 1. If it already has a scheme, try it directly
    if let url = URL(string: trimmed), url.scheme != nil {
        return url
    }

    // 2. If it looks like a domain, add https://
    if trimmed.contains(".") && !trimmed.contains(" ") {
        return URL(string: "https://\(trimmed)")
    }

    // 3. Otherwise, treat it as a search query
    let query = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    return URL(string: "https://www.google.com/search?q=\(query ?? "")")
}

#Preview {
    Main()
        .environmentObject(OnboardingViewVars())
        .environmentObject(UserAuthModel())
        .environmentObject(ViewModel(userAuth: UserAuthModel()))
        .environmentObject(Global())
        .environmentObject(AssistantViewModel())
        .environmentObject(TaskDetails())
}
