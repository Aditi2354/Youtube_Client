//
//  VideoPageActionButton.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.06.2023.
//

import SwiftUI

struct VideoPageActionButton<Content: View>: View {
    
    //MARK: Properties
    
    let content: () -> Content
    let action: VoidClosure
    
    //MARK: - Initialization
    
    init(action: @escaping VoidClosure,
         @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    //MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack {
                content()
            }
            .padding(.horizontal, 5)
        }
        .tint(.primary)
        .font(.system(size: 15))
        .padding(10)
        .background {
            Capsule(style: .continuous)
                .fill(Color(Resources.Colors.secondaryBackground))
        }
    }
}

//MARK: - Preview

struct VideoPageActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VideoPageActionButton {
            
        } content: {
            Image(systemName: "heart")
            Text("Favourite")
        }

    }
}
