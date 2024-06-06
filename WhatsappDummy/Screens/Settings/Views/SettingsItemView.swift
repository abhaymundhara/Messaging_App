//
//  SettingsItemView.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 02/06/2024.
//

import SwiftUI

struct SettingsItemView: View {
    let item: SettingsItem
    
    var body: some View {
        HStack{
            
            itemImageView()
                .frame(width: 30, height:30)
                .foregroundStyle(.white)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            Text(item.title)
                .font(.system(size: 18))
                .bold()
            
            Spacer()
            
        }
    }
    
    
    @ViewBuilder
    private func itemImageView() -> some View {
        switch item.imageType {
        case .systemImage:
            Image(systemName: item.imageName)
                .bold()
                .font(.callout)
        case .assetImage:
            Image(item.imageName)
                .renderingMode(.template)
                .padding(3)
        }
//        Image(systemName: item.imageName)

    }
}

#Preview {
    SettingsItemView(item: .chats)
}
