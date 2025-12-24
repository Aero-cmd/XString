//
//  XStringApp.swift
//  XString
//
//  Created by AeroStar on 11/12/2025.
//

import SwiftUI
internal import Combine

// MARK: TODO:

// make signin/signup flow that isnt included with onboarding.

@main
struct XStringApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.global.hasSeenOnboarding == false {
                    ContentView()
                } else if !appState.viewModel.isLoggedIn {
                   Login_signup()
                } else {
                    Main()
                }
            }
            .environmentObject(appState)
            .onAppear() {
                Task {
                    do {
                        try await appState.viewModel.getCurrentUser()
                    } catch {
                        print("failed to get user, proceeding with next action.")
                    }
                }
            }
        }
    }
}

@MainActor
class AppState: ObservableObject {
    @Published var onboardingVars = OnboardingViewVars()
    @Published var viewModel: ViewModel
    @Published var sharedText = UserAuthModel()
    @Published var global = Global()

    init() {
        let userAuth = UserAuthModel()
        self.viewModel = ViewModel(userAuth: userAuth)
        self.sharedText = userAuth
    }
}