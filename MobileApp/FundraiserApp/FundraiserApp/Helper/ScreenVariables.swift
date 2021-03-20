//
//  ScreenVariables.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

class ScreenVariables: ObservableObject {
    @Published var currentScreen: Int = 1
    @Published var color: String = "Default"
    @Published var user: User = User()
}
