//
//  ErrorStateView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/20/25.
//

import SwiftUI

struct ErrorStateView: View {
    let error:String
    var retryCallback: (()->())? = nil
    var body: some View {
        HStack{
            Spacer()
            VStack(spacing:16){
                Text(error)
                if let retryCallback {
                    Button("Retry", action: retryCallback)
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding(64)
    }
}

struct ErrorStateView_Previews: PreviewProvider{
    static var previews: some View{
        Group{
            ErrorStateView(error: "An Error Occured", retryCallback: {
                print("Tapped")
            })
                .previewDisplayName("With Retry Button")
            ErrorStateView(error: "An Error Occured")
                .previewDisplayName("Without Retry Button")
        }
    }
}
