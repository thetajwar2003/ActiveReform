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
            default:
                EventsView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
