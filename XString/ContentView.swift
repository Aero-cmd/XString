//
//  ContentView.swift
//  XString
//
//  Created by AeroStar on 11/12/2025.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    @EnvironmentObject var onboardingVars: OnboardingViewVars
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
                
                Text("XString")
                    .fontWidth(.expanded)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom, -6)
                Text("The most feature-rich \nbrowser.")
                    .font(.system(size: 25, weight: .heavy, design: .default))
                    .fontDesign(.rounded)
                    .padding(.leading)
                    .opacity(0.8)
                    .padding(.bottom)
                
                
                HStack {
                    Image(systemName: "network.badge.shield.half.filled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)   // or .scaledToFit()
                        .frame(height: 45)
                        .foregroundStyle(.purple)
                        .padding(.trailing)
                        
                    VStack(alignment: .leading) {
                        Text("Your Data Is Safe And Secure")
                            .font(.title3.bold())
                        Text("XString uses a system that allows only you to access your data and not anyone foreign.")
                    }
                    
                }
                .padding(.leading)
                HStack {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)   // or .scaledToFit()
                        .frame(height: 45)
                        .foregroundStyle(.purple)
                        .padding(.trailing)
                        
                    VStack(alignment: .leading) {
                        Text("Our Library Of Features")
                            .font(.title3.bold())
                        Text("XString has a entire collection of unique features never seen in a browser.")
                    }
                    
                }
                .padding(.top)
                .padding(.leading)
                
                HStack {
                    Image(systemName: "iphone.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)   // or .scaledToFit()
                        .frame(height: 45)
                        .foregroundStyle(.purple)
                        .padding(.trailing)
                        
                    VStack(alignment: .leading) {
                        Text("Our Easy To Navigate UI")
                            .font(.title3.bold())
                        Text("XString has an Apple-like UI/UX style to feel familiar but yet sleek.")
                    }
                    
                }
                .padding(.top)
                .padding(.leading)
                
                Spacer()
                
                NavigationLink {
                    Onboarding()
                } label: {
                    HStack {
                        Spacer()
                        Text("Get Started")
                            .padding(10)
                            .opacity(0.9)
                            .font(.title3.bold())
                        Spacer()
                    }
                }
                .onTapGesture {
                    Haptics.impact(.medium)
                }
                .glassEffect(.regular.interactive().tint(.purple))
                .padding()
                
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("by")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.4))
                        
                        Text("AERO")
                            .font(.system(size: 30, weight: .semibold))
                            .tracking(4)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.bottom, 10)
                    Spacer()
                }
                
            }
            .onAppear {
                UIImpactFeedbackGenerator(style: .light).prepare()
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
        .environmentObject(OnboardingViewVars())
}
