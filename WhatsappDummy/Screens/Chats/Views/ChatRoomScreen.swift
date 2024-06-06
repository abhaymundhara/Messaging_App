//
//  ChatRoomScreen.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 02/06/2024.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    
    
    var body: some View {
        MessageListView(viewModel)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            leadingNavItems()
            trailingNavItems()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom){
            TextInputArea(textMessage: $viewModel.textMessage) {
                viewModel.sendMessage()
            }
        }
    }
}

extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent{
        ToolbarItem(placement: .topBarLeading){
            HStack {
                Circle()
                    .frame(width: 35, height: 30)
                
                Text(channel.title)
                    .bold()
            }
        }
    }
    
    private func trailingNavItems() -> some ToolbarContent{
        ToolbarItemGroup(placement: .topBarTrailing){
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
}
    
    #Preview {
        NavigationStack {
            ChatRoomScreen(channel: .placeholder)
        }
    }

