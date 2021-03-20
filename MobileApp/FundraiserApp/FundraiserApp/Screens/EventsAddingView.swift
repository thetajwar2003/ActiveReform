//
//  EventsAddingView.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

struct EventsAddingView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var screen = ScreenVariables()
    @State var nameOfEvent = ""
    @State var name = ""
    @State var numberOfNames: Int = 1
    @State var names = [String]()
    @State var description = ""
    @State var money: Double = 0
    @State var tags = [String]()
    @State var type = ""

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
    
    func setUserName() {
        names.append(screen.user.firstName + " " + screen.user.lastName)
    }
    
    func addToListOfNames() {
        withAnimation {
            names.append(name)
            name = ""
        }
    }
    
    func postEvents(_ id: String, _ namesOfContributors: [String], nameOfEvent: String, description: String, money: Double, tags: [String], type: String) {
        let queryNamesOfContributors = "\(namesOfContributors)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let queryTags = "\(tags)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://active-reform.herokuapp.com/events/\(id)/\(queryNamesOfContributors)/\(nameOfEvent)/\(description)/\(money)/\(queryTags)/\(type)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            if let _ = try? JSONDecoder().decode([Events].self, from: data) { }
        }.resume()
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 0) {
                    Text("Name of Event")
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
                    TextField(nameOfEvent, text: $nameOfEvent)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 16 * 13)
                }
                .font(.body)
                .frame(height: UIScreen.main.bounds.height / 32)
                
                HStack(spacing: 0) {
                    Text("Contributors")
                        .foregroundColor(getForeground())
                    Text("*")
                        .foregroundColor(Color.red)
                    Spacer()
                }
                .font(.headline)
                .padding(.top)
                
                ForEach(names, id: \.self) { name in
                    HStack {
                        Text(name)
                            .foregroundColor(getForeground())
                            .font(.body)
                        Spacer()
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(getForeground())
                    TextField(name, text: $name, onCommit: addToListOfNames)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 16 * 13)
                }
                .font(.body)
                .frame(height: UIScreen.main.bounds.height / 32)
                
                HStack {
                    Text("Description")
                        .foregroundColor(getForeground())
                    Spacer()
                }
                .font(.headline)
                .padding(.top)
                
                
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 8 * 7)
            .padding(.top)
        }
        .onAppear(perform: setUserName)
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
