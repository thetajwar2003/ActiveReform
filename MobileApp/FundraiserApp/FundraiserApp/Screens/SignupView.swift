//
//  SignupView.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var screen: ScreenVariables
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    @State var confirm = ""
    @State var school = ""
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
    
    func subVerificationPassword(_ password: String) -> Bool {
        var pass = 0
        var verifications = ["letters": false, "digits": false, "special": false]
        for character in password.unicodeScalars {
            if !verifications["letters"]! {
                if CharacterSet.letters.contains(character) {
                    pass += 1
                    verifications["letters"] = true
                }
            }
            if !verifications["digits"]! {
                if CharacterSet.decimalDigits.contains(character) {
                    pass += 1
                    verifications["digits"] = true
                }
            }
            if !verifications["special"]! {
                if !CharacterSet.letters.contains(character) && !CharacterSet.letters.contains(character) {
                    pass += 1
                verifications["special"] = true
                }
            }
            if pass >= 2 {
                return true
            }
        }
        return false
    }
    
    func confirmAccount() -> Bool {
        if confirm != password {
            return false
        }
        if password.count < 8 || confirm.count < 8 {
            return false
        }
        if (subVerificationPassword(password) && subVerificationPassword(confirm)) == false {
            return false
        }
        return true
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
                            return
                        }
                    }
                }
            }
        }.resume()
    }

    func postUser() {
        let id = UUID()
        let queryFirstName = firstName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryLastName = lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let querySchool = school.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryListMade = "\([])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryListSigned = "\([])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://active-reform.herokuapp.com/users/\(id)/\(queryFirstName)/\(queryLastName)/\(queryEmail)/\(queryPassword)/\(querySchool)/\(queryListMade)/\(queryListSigned)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let params = [
            "id": "\(id)",
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "school": school,
            "idOfMade": [],
            "idOfSigned": []
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let _ = try? JSONDecoder().decode([User].self, from: data) { }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Signup")
                        .foregroundColor(getForeground())
                        .font(.largeTitle)
                }
                ZStack {
                    Text("")
                        .frame(width: UIScreen.main.bounds.width)
                    Text("")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 8 * 5)
                        .background(getBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                    VStack(spacing: 0) {
                        VStack {
                            HStack(spacing: 0) {
                                Text("First Name")
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
                                TextField(firstName, text: $firstName)
                                    .foregroundColor(getForeground())
                                    .autocapitalization(.none)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 32)
                            }
                            .font(.body)
                        }
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("Last Name")
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
                                TextField(lastName, text: $lastName)
                                    .foregroundColor(getForeground())
                                    .autocapitalization(.none)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 32)
                            }
                            .font(.body)
                        }
                        
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
                                SecureField(password, text: $password)
                                    .foregroundColor(getForeground())
                                    .autocapitalization(.none)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 32)
                            }
                            .font(.body)
                        }
                        .frame(width: UIScreen.main.bounds.width / 16 * 13)
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("Confirm Password")
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
                                        TextField(confirm, text: $confirm)
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
                                        SecureField(confirm, text: $confirm)
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
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("School")
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
                                TextField(school, text: $school)
                                    .foregroundColor(getForeground())
                                    .autocapitalization(.none)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 32)
                            }
                            .font(.body)
                        }
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                Text("Back")
                            }
                            .font(.body)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .onTapGesture {
                                withAnimation {
                                    screen.currentScreen = 1
                                }
                            }
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(getForeground())
                                Text("Signup")
                            }
                            .font(.body)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .onTapGesture {
                                if confirmAccount() {
                                    postUser()
                                    withAnimation {
                                        screen.currentScreen = 0
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width / 16 * 13, height: UIScreen.main.bounds.height / 20)
                }
            }
            .frame(width: UIScreen.main.bounds.width / 16 * 13, height: UIScreen.main.bounds.height / 8 * 5)
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
