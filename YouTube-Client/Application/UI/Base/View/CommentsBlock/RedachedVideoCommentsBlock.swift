//
//  RedachedVideoCommentsBlock.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import SwiftUI

struct RedachedVideoCommentsBlock: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Comments")
                    .bold()
                
                Text("0")
                    .foregroundStyle(.secondary)
            }
            .font(.callout)
            
            HStack(spacing: 10.0) {
                Circle()
                    .fill(.secondary.opacity(0.5))                
                    .frame(width: 25, height: 25)
                    
                Text("Top comment")
            }
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(Resources.Colors.secondaryBackground))
        }
        .redacted(reason: .placeholder)
    }
}

struct RedachedVideoCommentsBlock_Previews: PreviewProvider {
    static var previews: some View {
        RedachedVideoCommentsBlock()
    }
}
