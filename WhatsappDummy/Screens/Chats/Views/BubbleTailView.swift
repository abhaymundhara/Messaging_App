//
//  BubbleTailView.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 02/06/2024.
//

import SwiftUI

struct BubbleTailView: View {
 
    var direction: MessageDirection
    private var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    var body: some View {
        Image(direction == .sent ? .outgoingTail : .incomingTail)
            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
            .resizable()
            .frame(width: 10, height: 10)
            .offset(y: 3)
            .foregroundStyle(backgroundColor)
        
    }
}

#Preview {
    ScrollView{
        BubbleTailView(direction: .sent)
        BubbleTailView(direction: .recieved)
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.1))
}
