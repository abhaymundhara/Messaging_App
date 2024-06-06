//
//  RootScreen.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 03/06/2024.
//

import SwiftUI

struct RootScreen: View {
    @StateObject private var viewModel = RootScreenModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
            
        case.loggedIn(let loggedInUser):
            MainTabView(loggedInUser)
            
        case.loggedOut:
            LoginScreen()
        }
    }
}

#Preview {
    RootScreen()
}
