//
//  LoginView.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var screen: ScreenVariables
    @State var email = ""
    @State var password = ""
    @State var showPassword = false
    
    func getForeground() -> Color {
        if screen.color == "Default" {
            return colorScheme != .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        else if screen.color == "Light"{
            return Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
        else {
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
    }
    
    func getBackground() -> Color {
        if screen.color == "Default" {
            return colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black
        }
        else if screen.color == "Light"{
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        else {
            return Color.black
        }
    }
    
    func getUser(email: String, password: String) {
        let queryEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://active-reform.herokuapp.com/users/\(queryEmail)/\(queryPassword)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                for user in decoded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        screen.user = user
                        if screen.user.firstName != "" {
                            withAnimation {
                                screen.currentScreen = 0
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Login")
                        .foregroundColor(getForeground())
                        .font(.largeTitle)
                }
                ZStack {
                    Text("")
                        .frame(width: UIScreen.main.bounds.width)
                    Text("")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 4)
                        .background(getBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                    VStack(spacing: 0) {
                        VStack {
                            HStack(spacing: 0) {
                                Text("Email")
                                    .foregroundColor(getForeground())
                                Text("*")
                                    .foregroundColor(Color.red)
                                Spacer()
                            }
                            .font(.headline)
                            .padding(.top)

                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                TextField(email, text: $email)
                                    .foregroundColor(getForeground())
                                    .autocapitalization(.none)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 32)
                            }
                            .font(.body)
                        }
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("Password")
                                    .foregroundColor(getForeground())
                                Text("*")
                                    .foregroundColor(Color.red)
                                Spacer()
                            }
                            .font(.headline)
                            .padding(.top)

                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                    .frame(width: UIScreen.main.bounds.width / 16 * 13)
                                HStack {
                                    if showPassword {
                                        TextField(password, text: $password)
                                            .foregroundColor(getForeground())
                                            .autocapitalization(.none)
                                            .frame(width: UIScreen.main.bounds.width / 16 * 10.5, height: UIScreen.main.bounds.height / 32)
                                            .offset(x: UIScreen.main.bounds.width / 32)
                                        Spacer()
                                        Image(systemName: "eye.slash.fill")
                                            .foregroundColor(getForeground())
                                            .onTapGesture {
                                                withAnimation {
                                                    showPassword.toggle()
                                                }
                                            }
                                            .padding(.trailing)
                                    }
                                    else {
                                        SecureField(password, text: $password)
                                            .foregroundColor(getForeground())
                                            .autocapitalization(.none)
                                            .frame(width: UIScreen.main.bounds.width / 16 * 10.5, height: UIScreen.main.bounds.height / 32)
                                            .offset(x: UIScreen.main.bounds.width / 32)
                                        Spacer()
                                        Image(systemName: "eye.fill")
                                            .foregroundColor(getForeground())
                                            .onTapGesture {
                                                withAnimation {
                                                    showPassword.toggle()
                                                }
                                            }
                                            .padding(.trailing)
                                    }
                                }
                            }
                            .font(.body)
                        }
                        .frame(width: UIScreen.main.bounds.width / 16 * 13)
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                Text("Sign Up")
                            }
                            .font(.body)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .onTapGesture {
                                withAnimation {
                                    screen.currentScreen = 2
                                }
                            }
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                Text("Login")
                            }
                            .font(.body)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .onTapGesture {
                                getUser(email: email, password: password)
                            }
                        }
                        .padding(.top)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width / 16 * 13, height: UIScreen.main.bounds.height / 20)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 16 * 13, height: UIScreen.main.bounds.height / 4)
            .navigationBarTitle("Fundraiser App")
        }
        .offset(y: UIScreen.main.bounds.height / -16)
        
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}


struct User: Codable {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var school: String = ""
    var idOfMade = [String]()
    var idOfSigned = [String]()
}
