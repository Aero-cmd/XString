//
//  Onboarding.swift
//  XString
//
//  Created by AeroStar on 13/12/2025.
//

import SwiftUI
internal import Combine
import AppwriteModels
import Foundation

// MARK: TODO:

// add .task to the else {} ver of the "next/confirm" navigation link to add actually importing data
// make the frame color settings actually work
// add more importing options & make them work
// add more account options
// polish UI/UX

// MARK: Views:

struct Onboarding: View {
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    @State private var showAlert = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
                
                Text("Your Style")
                    .fontWidth(.expanded)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom, -6)
                Text("Choose your home webpage background.")
                    .font(.system(size: 25, weight: .heavy, design: .default))
                    .fontDesign(.rounded)
                    .padding(.leading)
                    .opacity(0.8)
                    .padding(.bottom)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        Button {
                            onboardingVars.image = "1"
                            Haptics.selection()
                        } label: {
                            
                            Image("1")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "2"
                            Haptics.selection()
                        } label: {
                            Image("2")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "3"
                            Haptics.selection()
                        } label: {
                            Image("3")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "4"
                            Haptics.selection()
                        } label: {
                            Image("4")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "5"
                            Haptics.selection()
                        } label: {
                            Image("5")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "6"
                            Haptics.selection()
                        } label: {
                            Image("6")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "7"
                            Haptics.selection()
                        } label: {
                            Image("7")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "8"
                            Haptics.selection()
                        } label: {
                            Image("8")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "9"
                            Haptics.selection()
                        } label: {
                            Image("9")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                        Button {
                            onboardingVars.image = "10"
                            Haptics.selection()
                        } label: {
                            Image("10")
                                .resizable()
                                .frame(width: 250, height: 450)
                                .cornerRadius(25)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                NavigationLink {
                    ImagePreview()
                } label: {
                    HStack {
                        Text("Preview")
                        Image(systemName: "arrow.right")
                    }
                }
                .foregroundStyle(.blue)
                .padding(.leading)
                .padding(.top)
                Spacer()

                
                NavigationLink {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        BrowsingData()
                    }
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Next")
                            .padding(10)
                            .opacity(0.9)
                            .font(.title3.bold())
                        Spacer()
                    }
                }
                .disabled(onboardingVars.image.isEmpty)
                .onTapGesture {
                    if onboardingVars.image.isEmpty {
                        Haptics.notification(.error)
                        showAlert = true
                    } else {
                        Haptics.impact(.medium)
                    }
                }
                .glassEffect(.regular.interactive().tint(.purple))
                .padding()
                
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: 10, height: 10)
                        .opacity(0.9)
                        .transition(.opacity)
                    Circle()
                        .frame(width: 10, height: 10)
                        .opacity(0.6)
                        .transition(.opacity)
                    Circle()
                        .frame(width: 10, height: 10)
                        .opacity(0.6)
                        .transition(.opacity)
                    Spacer()
                }
                
            }
            .alert("Error", isPresented: $showAlert) {
                Button("Ok") {
                    showAlert = false
                }
            } message: {
                Text("No image is selected!")
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        }
        .navigationBarBackButtonHidden()
    }
}



struct BrowsingData: View {
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    @State private var browsingDataImportMode: SelectedBrowsingDataMode = .none
    @State private var showAlert = false
    @Namespace var namespace
    @State private var historyIsOn = false
    @State private var tabsIsOn = false
    @State private var cookiesIsOn = false
    @State private var extensionsIsOn = false
    @Environment(\.dismiss) var dismiss
    @State private var nextClicked = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                if !nextClicked {
                    Text("Import Browsing Data.")
                        .fontWidth(.expanded)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.leading)
                        .padding(.top)
                        .padding(.bottom, -6)
                    Text("Start right where you left off.")
                        .font(.system(size: 25, weight: .heavy, design: .default))
                        .fontDesign(.rounded)
                        .padding(.leading)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Import from safari.")
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.top)
                                .font(.headline.bold())
                                .matchedGeometryEffect(id: "importsafari1", in: namespace)
                            Spacer()
                        }
                        Text("Import your cookies, History, and tabs \nfrom safari.")
                            .padding(.leading)
                            .padding(.bottom)
                        
                    }
                    .glassEffect(browsingDataImportMode == .safari ? .clear.interactive().tint(.blue.opacity(0.2)) : .clear.interactive().tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                    .padding(.trailing)
                    .padding(.leading)
                    .matchedGeometryEffect(id: "safaribox", in: namespace)
                }
                if nextClicked && browsingDataImportMode == .safari {
                    Text("Import From \nSafari")
                        .fontWidth(.expanded)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.leading)
                        .padding(.top)
                        .padding(.bottom, -6)
                    Text("Bring your browsing experience from Safari.")
                        .font(.system(size: 25, weight: .heavy, design: .default))
                        .padding(.leading)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Say what you want to import.")
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.top)
                                .font(.headline.bold())
                            Spacer()
                        }
                        Text("Select from these options on what you \nwant to import.")
                            .padding(.leading)
                        Divider()
                        VStack(spacing: 10) {
                            Toggle("Browsing History", isOn: $historyIsOn)
                                .onChange(of: historyIsOn) { _ in
                                    Haptics.selection()
                                }
                                .padding(.leading)
                                .padding(.trailing)
                            
                            Toggle("Tabs", isOn: $tabsIsOn)
                                .onChange(of: tabsIsOn) { _ in
                                    Haptics.selection()
                                }
                                .padding(.leading)
                                .padding(.trailing)
                            
                            Toggle("Cookies", isOn: $cookiesIsOn)
                                .onChange(of: cookiesIsOn) { _ in
                                    Haptics.selection()
                                }
                                .padding(.leading)
                                .padding(.trailing)
                            
                            Toggle("Extensions", isOn: $extensionsIsOn)
                                .onChange(of: extensionsIsOn) { _ in
                                    Haptics.selection()
                                }
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.bottom)
                        }
                    }
                    .glassEffect(.clear.tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                    .padding(.trailing)
                    .padding(.leading)
                    .matchedGeometryEffect(id: "safaribox", in: namespace)
                }
                Spacer()
                if !nextClicked {
                    HStack {
                        Spacer()
                        NavigationLink {
                            Login_signup()
                        } label: {
                            Text("Skip importing.")
                                .opacity(0.7)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.bouncy) {
                                nextClicked = false
                            }
                        } label: {
                            Text("Go back.")
                                .opacity(0.7)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                }
                if !nextClicked {
                    Button {
                        withAnimation(.bouncy) {
                            nextClicked = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Next")
                                .padding(10)
                                .opacity(0.9)
                                .font(.title3.bold())
                            Spacer()
                        }
                    }
                    .disabled(onboardingVars.isABrowsingDataModeSelected == false)
                    .onTapGesture {
                        if onboardingVars.isABrowsingDataModeSelected == false {
                            showAlert = true
                            Haptics.notification(.error)
                        } else {
                            Haptics.impact(.medium)
                        }
                    }
                    .glassEffect(.regular.interactive().tint(.purple))
                    .padding()
                } else {
                    NavigationLink {
                        // next view
                    } label: {
                        HStack {
                            Spacer()
                            Text("Confirm")
                                .padding(10)
                                .opacity(0.9)
                                .font(.title3.bold())
                            Spacer()
                        }
                    }
                    .disabled(onboardingVars.isABrowsingDataModeSelected == false)
                    .onTapGesture {
                        if onboardingVars.isABrowsingDataModeSelected == false {
                            showAlert = true
                            Haptics.notification(.error)
                        } else {
                            Haptics.impact(.medium)
                        }
                    }
                    .glassEffect(.regular.interactive().tint(.purple))
                    .padding()
                    // add .task here!
                }
                
                    HStack {
                        Spacer()
                        Circle()
                            .frame(width: 10, height: 10)
                            .opacity(0.6)
                            .transition(.opacity)
                        Circle()
                            .frame(width: 10, height: 10)
                            .opacity(0.8)
                            .transition(.opacity)
                        Circle()
                            .frame(width: 10, height: 10)
                            .opacity(0.6)
                            .transition(.opacity)
                        Spacer()
                    }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("Ok") {
                    showAlert = false
                }
                NavigationLink("Skip importing.") {
                    Login_signup()
                }
                .onTapGesture {
                    Task {
                        showAlert = false
                    }
                }
                .buttonStyle(.plain)
            } message: {
                Text("You havent selected a import option!")
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: Helpers / Extra Views

struct ImagePreview: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    @State private var showList = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack() {
                    Text("Preview")
                        .fontWidth(.expanded)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
                    Button {
                        showList.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                    .imageScale(.large)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .padding(.bottom, 10)
                
                if !onboardingVars.image.isEmpty {
                    HStack {
                        Spacer()
                        Image("frameiphone")
                            .resizable()
                            .aspectRatio(contentMode: .fit)   // or .scaledToFit()
                            .frame(height: 600)
                            .background {
                                
                                Image(onboardingVars.image)
                                    .resizable()
                                    .frame(width: 270, height: 580)
                                    .cornerRadius(35)
                                    .shadow(color: .black.opacity(0.35), radius: 40, y: 20)
                                    .overlay(alignment: .top) {
                                        VStack(spacing: 24) {
                                            // MARK: Address Bar
                                            RoundedRectangle(cornerRadius: 18)
                                                .frame(height: 56)
                                                .foregroundStyle(.clear)
                                            
                                                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 18))
                                                .overlay(
                                                    HStack {
                                                        Image(systemName: "globe")
                                                        Text("Search or enter website")
                                                            .font(.system(.body, design: .rounded))
                                                            .opacity(0.7)
                                                        Spacer()
                                                    }
                                                        .padding(.horizontal, 16)
                                                )
                                                .opacity(0.9)
                                                .padding(.top, 35)
                                            
                                            // MARK: Quick Actions
                                            HStack(spacing: 16) {
                                                ForEach(["bookmark", "square.on.square", "ellipsis"], id: \.self) { icon in
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .frame(width: 68, height: 68)
                                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
                                                        .foregroundStyle(.clear)
                                                        .overlay(
                                                            Image(systemName: icon)
                                                                .font(.system(size: 22))
                                                        )
                                                        .opacity(0.6)
                                                }
                                            }
                                            
                                            // MARK: Web Content Preview
                                            RoundedRectangle(cornerRadius: 28)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 280)
                                                .foregroundStyle(.clear)
                                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
                                                .overlay(
                                                    VStack(spacing: 12) {
                                                        Image(systemName: "safari")
                                                            .font(.system(size: 36))
                                                            .opacity(0.6)
                                                        
                                                        Text("Web content preview")
                                                            .font(.system(.title3, design: .rounded))
                                                            .opacity(0.6)
                                                    }
                                                )
                                                .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
                                                .opacity(0.85)
                                        
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.top, 16)
                                        .padding(.bottom)
                                        .foregroundStyle(.black)
                                    }
                            }
                        Spacer()
                    }
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Please choose an image")
                            .font(.system(size: 25, weight: .heavy, design: .default))
                            .fontDesign(.rounded)
                            .opacity(0.8)
                        Spacer()
                    }
                }
                    Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Go Back")
                            .padding(10)
                            .opacity(0.9)
                            .font(.title3.bold())
                        Spacer()
                    }
                }
                .glassEffect(.regular.interactive().tint(.purple))
                .padding()
            }
            .sheet(isPresented: $showList) {
                SettingsForPreview()
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .navigationBarBackButtonHidden()
    }
}

struct SettingsForPreview: View {
    @State private var selectedColor: FrameColor = .silver
    var body: some View {
        VStack {
            List {
                Section("Frame") {
                    VStack(alignment: .leading) {
                        Text("Frame Color")
                            .foregroundStyle(.black)
                        Picker("Color", selection: $selectedColor) {
                            Text("Silver").tag(FrameColor.silver)
                            Text("Cosmic Orange").tag(FrameColor.cosmicOrange)
                            Text("Deep Blue").tag(FrameColor.deepBlue)
                        }
                        .pickerStyle(.segmented)
                        .listRowBackground(Color.white.opacity(0.25))
                        if selectedColor == .silver {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color.gray
                                )
                                .frame(width: 100, height: 30)
                        }
                        if selectedColor == .cosmicOrange {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color.orange
                                )
                                .frame(width: 100, height: 30)
                                .brightness(0.1)
                        }
                        if selectedColor == .deepBlue {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color.blue
                                )
                                .frame(width: 100, height: 30)
                                .brightness(-0.3)
                        }
                    }
                }
            }
            .foregroundStyle(.white)
            .scrollContentBackground(.hidden)
            .background(.black)
        }
    }
}