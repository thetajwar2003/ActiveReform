//
//  EventsView.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

struct EventsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var screen: ScreenVariables
    @State var namesOfEvents = [String]()
    @State var names = [[String]]()
    @State var descriptions = [String]()
    @State var money = [Double]()
    @State var tags = [[String]]()
    @State var type = [String]()
    @State var addingPressed = false
    
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
    
    func eventTiles(eventName: String, name: String, description: String, tag: String, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Text("")
                .frame(width: UIScreen.main.bounds.width)
            Text("")
                .multilineTextAlignment(.leading)
                .foregroundColor(getForeground())
                .frame(width: width, height: height)
                .background(getBackground())
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
            VStack {
                HStack {
                    Text(eventName)
                        .multilineTextAlignment(.leading)
                        .font(.headline)
                        .foregroundColor(getForeground())
                        .background(getBackground())
                    Spacer()
                }
                HStack {
                    Text("Created By: \(name)")
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(getForeground())
                        .background(getBackground())
                    Spacer()
                }
                Rectangle()
                    .fill(getForeground())
                    .frame(width: width, height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                HStack {
                    Text("\(description)")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(getForeground())
                        .background(getBackground())
                    Spacer()
                }
                Spacer()
                Rectangle()
                    .fill(getForeground())
                    .frame(width: width, height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                HStack {
                    Text("\(tag)")
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(getForeground())
                        .background(getBackground())
                    Spacer()
                }
            }
            .frame(width: width - width / 8, height: height - height / 8)
        }
    }
    
    func getEvents() {
        guard let url = URL(string: "https://active-reform.herokuapp.com/events/Jonathan338833&&") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            if let decoded = try? JSONDecoder().decode([Events].self, from: data) {
                for event in decoded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        if event.namesOfContributors != [] {
                            names.append(event.namesOfContributors)
                            namesOfEvents.append(event.nameOfEvent)
                            descriptions.append(event.description)
                            tags.append(event.tags)
                        }
                    }
                }
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Events")
                    .font(.system(size: UIScreen.main.bounds.width / 12))
                    .fontWeight(.bold)
                    .padding(.leading)
                    .foregroundColor(getForeground())
                Spacer()
                Image(systemName: "plus.app")
                    .font(.system(size: UIScreen.main.bounds.width / 12))
                    .padding(.trailing)
                    .foregroundColor(getForeground())
                    .onTapGesture {
                        withAnimation {
                            addingPressed = true
                        }
                    }
            }
            Rectangle()
                .fill(getForeground())
                .frame(width: UIScreen.main.bounds.width, height: 1)
                .edgesIgnoringSafeArea(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<namesOfEvents.count, id: \.self) { index in
                    eventTiles(eventName: namesOfEvents[index], name: formatNames(names[index]), description: descriptions[index], tag: formatTags(tags[index]), width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 4)
                        .offset(y: UIScreen.main.bounds.height / 128)
                }
            }
            .offset(y: UIScreen.main.bounds.height / -128)
        }
        .sheet(isPresented: $addingPressed) {
            EventsAddingView(screen: screen)
        }
        .onAppear(perform: getEvents)
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

struct Events: Codable {
    var id: String = ""
    var namesOfContributors = [String]()
    var nameOfEvent: String = ""
    var description: String = ""
    var money: Double = 0
    var tags = [String]()
    var type: String = ""
}

func formatNames(_ listOfNames: [String]) -> String {
    var string = ""
    for name in listOfNames {
        string += (name + ", ")
    }
    return String(string[string.startIndex..<string.index(string.endIndex, offsetBy: -2)])
}

func formatTags(_ listOfTags: [String]) -> String {
    var string = ""
    for name in listOfTags {
        string += ("#" + name + ", ")
    }
    return String(string[string.startIndex..<string.index(string.endIndex, offsetBy: -2)])
}
