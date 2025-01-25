//
//  LoadingStateView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/20/25.
//

import SwiftUI

struct LoadingStateView: View {

    var body: some View {
        HStack{
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
        
    }
}

struct LoadingStateView_Previews: PreviewProvider{
    static var previews: some View{
        LoadingStateView()
    }
}
