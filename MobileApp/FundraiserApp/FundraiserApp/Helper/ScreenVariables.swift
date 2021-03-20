//
//  ScreenVariables.swift
//  FundraiserApp
//
//  Created by Jonathan Pang on 3/20/21.
//

import SwiftUI

class ScreenVariables: ObservableObject {
    @Published var currentScreen: Int = 0
    @Published var color: String = "Default"
    @Published var user: User = User()
}

struct User: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var school: String = ""
}
