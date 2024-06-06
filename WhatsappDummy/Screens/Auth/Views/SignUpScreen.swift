//
//  SignUpScreen.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 03/06/2024.
//

import SwiftUI


struct SignUpScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authScreenModel: AuthScreenModel

    var body: some View {
        VStack {
            Spacer()
            
            AuthHeaderView()
            
            AuthTextField(type: .email, text: $authScreenModel.email)
            
            let userNameType = AuthTextField.InputType.custom("Username", "at")
            
            AuthTextField(type: userNameType, text: $authScreenModel.username)
            
            AuthTextField(type: .password, text: $authScreenModel.password)
            
            AuthButton(title: "Create an account"){
                Task {
                    await authScreenModel.handleSignUp()
                }
            }
            .disabled(authScreenModel.disableSignUpButton)
            
            Spacer()
            backButton()
                .padding(.bottom, 25)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background{
            LinearGradient(colors: [.orange, .yellow.opacity(0.8), .teal], startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private func backButton() -> some View {
        NavigationLink {
         LoginScreen()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                    Text("Already have an account? ")
                    +
                    Text("Log in") .bold()
                )
                
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpScreen(authScreenModel: AuthScreenModel())
}
