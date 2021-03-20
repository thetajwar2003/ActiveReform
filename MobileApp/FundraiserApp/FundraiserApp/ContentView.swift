//
//  ContentView.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var screen = ScreenVariables()

    var body: some View {
        switch screen.currentScreen {
        case 1:
            LoginView(screen: screen)
        case 2:
            SignupView(screen: screen)
        default:
            EventsView(screen: screen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
