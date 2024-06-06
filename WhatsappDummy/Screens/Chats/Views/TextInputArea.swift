//
//  TextInputArea.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 02/06/2024.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    let onSendHandler:() -> Void
    private var disableSendButton: Bool {
        return textMessage.isEmptyorWhiteSpace
    }
    
    @State private var text = ""
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            imagePickerButton()
                .padding(2)
            audioPickerButton()
            messageTextField()
            sendMessageButton()
                .disabled(disableSendButton)
                .grayscale(disableSendButton ? 0.8 : 0)
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .background(.whatsAppWhite)
    }
    
    private func messageTextField() -> some View {
        TextField("", text: $textMessage    , axis: .vertical)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous) .fill(.thinMaterial)
            )
            .overlay(textViewBorder())
    }
    
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5), lineWidth: 1)
    }
    
    
    private func imagePickerButton() -> some View {
        Button{
            
        } label: {
            Image(systemName: "photo.on.rectangle").foregroundColor(.whatsAppBlack).imageScale(.large)
        }
    }
    
    
    private func audioPickerButton() -> some View {
        Button{
            
        } label: {
            Image(systemName: "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 3)
            
        }
    }
    
    private func sendMessageButton() -> some View {
        Button{
            onSendHandler()
        } label: {
            Image(systemName: "paperplane.fill")
                .fontWeight(.heavy)
                .padding(6)
                .foregroundStyle(.white)
                .background(Color(.blue))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
    
}

#Preview {
    TextInputArea(textMessage: .constant("")) {
        
    }
}
