//
//  EmptyStateView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/20/25.
//

import SwiftUI

struct EmptyStateView: View {
    let text: String
    var body: some View {
        HStack{
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundColor(Color(.systemGray))
            Spacer()
        }
        .padding(64)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
}

struct EmptyStateView_Previews: PreviewProvider{
    static var previews: some View{
        EmptyStateView(text: "No Data available")
    }
}
