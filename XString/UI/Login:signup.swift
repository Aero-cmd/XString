//
//  Login:signup.swift
//  XString
//
//  Created by AeroStar on 21/12/2025.
//

import SwiftUI

struct Login_signup: View {
        @EnvironmentObject var onboardingVars: OnboardingViewVars
        @EnvironmentObject var viewmodel: ViewModel
        @State private var accountMode: SelectedAccountMode = .none
        @EnvironmentObject var sharedText: UserAuthModel
        @Namespace var namespace
        @Environment(\.dismiss) var dismiss
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 10) {
                    if accountMode == .none {
                        
                        Text("Account Setup")
                            .fontWidth(.expanded)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -6)
                        Text("Login/Create an account to access more features.")
                            .font(.system(size: 25, weight: .heavy, design: .default))
                            .fontDesign(.rounded)
                            .padding(.leading)
                            .opacity(0.8)
                            .padding(.bottom)
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("Signup")
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .padding(.top)
                                        .font(.headline.bold())
                                        .matchedGeometryEffect(id: "signup1", in: namespace)
                                    Spacer()
                                }
                                Text("Create an account with us.")
                                    .padding(.leading)
                                    .padding(.bottom)
                                
                            }
                            .onTapGesture {
                                if !onboardingVars.isAAccountModeSelected {
                                    withAnimation(.bouncy) {
                                        onboardingVars.isAAccountModeSelected = true
                                        accountMode = .signup
                                        Haptics.selection()
                                    }
                                }
                            }
                            .contentShape(Rectangle())
                            .glassEffect(.clear.interactive().tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                            .padding(.trailing)
                            .padding(.leading)
                            .matchedGeometryEffect(id: "signupbox", in: namespace)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Login")
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(.top)
                                    .font(.headline.bold())
                                Spacer()
                            }
                            Text("Login to your account with us")
                                .padding(.leading)
                                .padding(.bottom)
                            
                        }
                        .onTapGesture {
                            if !onboardingVars.isAAccountModeSelected {
                                withAnimation(.bouncy) {
                                    onboardingVars.isAAccountModeSelected = true
                                    accountMode = .login
                                    Haptics.selection()
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .glassEffect(.clear.interactive().tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                        .padding(.trailing)
                        .padding(.leading)
                        .matchedGeometryEffect(id: "signinbox", in: namespace)
                        
                        }
                    }
                    
                    if accountMode == .signup {
                        Text("Account Setup")
                            .fontWidth(.expanded)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -6)
                        Text("Login/Create an account to access more features.")
                            .font(.system(size: 25, weight: .heavy, design: .default))
                            .padding(.leading)
                            .opacity(0.8)
                            .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Create an account")
                                    .font(.headline.bold())
                                Spacer()
                                Button {
                                    withAnimation(.bouncy) {
                                        onboardingVars.isAAccountModeSelected = false
                                        accountMode = .none
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top)
                            Text("Make an Aero ID/Account with us.")
                                .padding(.leading)
                            Divider()
                            VStack(spacing: 10) {
                                TextField("Name", text: $sharedText.nameText)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                                    .padding()
                                    .glassEffect(.regular.interactive().tint(.black.opacity(0.4)))
                                    .padding(.leading)
                                    .padding(.trailing, 15)
                                TextField("Email", text: $sharedText.emailText)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                                    .padding()
                                    .glassEffect(.regular.interactive().tint(.black.opacity(0.4)))
                                    .padding(.leading)
                                    .padding(.trailing, 15)
                                SecureField("Password", text: $sharedText.passwordText)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                                    .padding()
                                    .glassEffect(.regular.interactive().tint(.black.opacity(0.4)))
                                    .padding(.leading)
                                    .padding(.trailing, 15)
                                Button {
                                    Task {
                                        try? await viewmodel.createUser(name: sharedText.nameText, email: sharedText.emailText, password: sharedText.passwordText)
                                    }
                                } label: {
                                        Text("Create a Account.")
                                            .bold()
                                            .padding()
                                }
                                .glassEffect(.clear.interactive())
                                .padding(.bottom)
                            }
                        }
                        .glassEffect(.clear.tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                        .padding(.trailing)
                        .padding(.leading)
                        .matchedGeometryEffect(id: "signupbox", in: namespace)
                    }
                    if accountMode == .login {
                        Text("Account Setup")
                            .fontWidth(.expanded)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -6)
                        Text("Login/Create an account to access more features.")
                            .font(.system(size: 25, weight: .heavy, design: .default))
                            .padding(.leading)
                            .opacity(0.8)
                            .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Login")
                                    .font(.headline.bold())
                                Spacer()
                                Button {
                                    withAnimation(.bouncy) {
                                        onboardingVars.isAAccountModeSelected = false
                                        accountMode = .none
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top)
                            Text("Login to your Aero ID / Account with us")
                                .padding(.leading)
                            Divider()
                            VStack(spacing: 10) {
                                TextField("Email", text: $sharedText.emailText)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                                    .padding()
                                    .glassEffect(.regular.interactive().tint(.black.opacity(0.4)))
                                    .padding(.leading)
                                    .padding(.trailing, 15)
                                SecureField("Password", text: $sharedText.passwordText)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                                    .padding()
                                    .glassEffect(.regular.interactive().tint(.black.opacity(0.4)))
                                    .padding(.leading)
                                    .padding(.trailing, 15)
                                Button {
                                    Task {
                                        try? await viewmodel.login(email: sharedText.emailText, password: sharedText.passwordText)
                                    }
                                } label: {
                                        Text("Login")
                                            .bold()
                                            .padding()
                                }
                                .glassEffect(.clear.interactive())
                                .padding(.bottom)
                            }
                        }
                        .glassEffect(.clear.tint(.purple.opacity(0.2)), in: RoundedRectangle(cornerRadius: 25))
                        .padding(.trailing)
                        .padding(.leading)
                        .matchedGeometryEffect(id: "signinbox", in: namespace)
                    }
                    Spacer()
                    if accountMode == .none {
                        NavigationLink {
                            Main()
                        } label: {
                            HStack {
                                Spacer()
                                Text("No, ill pass.")
                                    .bold()
                                    .opacity(0.7)
                                    .padding(10)
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            if viewmodel.hasError == true {
                                Haptics.notification(.error)
                            } else {
                                Haptics.impact(.medium)
                            }
                        }
                        .glassEffect(.regular.interactive().tint(.purple))
                        .padding()
                        
                    }
                }
                .alert(viewmodel.hasError ? "Error" : "Success", isPresented: $viewmodel.showAlert) {
                    if viewmodel.hasError {
                        Button("Try Again") {}
                    } else {
                        NavigationLink("Ok") {
                            Main()
                        }
                    }
                } message: {
                    Text(viewmodel.alertMessage)
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


#Preview {
    Login_signup()
        .environmentObject(OnboardingViewVars())
        .environmentObject(UserAuthModel())
        .environmentObject(ViewModel(userAuth: UserAuthModel()))
        .environmentObject(Global())
}