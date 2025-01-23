//
//  AppViewModel.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/21/25.
//

import Foundation
import ApiStocks
import SwiftProtobuf

@MainActor // this AppViewModel is to use in main thread
class AppViewModel: ObservableObject{
    @Published var tickers: [Ticker] = []
    
}
