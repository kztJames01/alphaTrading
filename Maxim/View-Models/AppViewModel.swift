//
//  AppViewModel.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/21/25.
//

import Foundation
import ApiStocks
import SwiftUI

@MainActor // this AppViewModel is to use in main thread
class AppViewModel: ObservableObject{
    @Published var stockWatchlist: [Ticker] = []{
        didSet { saveWatchlistItems() }
    }
    
    @Published var subtitleText: String
    
    var titleText = "Maxim"
    var emptyTickersText = "Search & add symbol to see stock quotes"
    var attributionText = "Powered by YH Finance API"
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        return df
    }()
    
    let tickerList: TickerList
    
    init(tickerList: TickerList = TickerPList()) {
    
        self.subtitleText = subtitleDateFormatter.string(from: Date())
        self.tickerList = tickerList
    }
    
    private func loadWatchlistItems(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                self.stockWatchlist = try await tickerList.load()
            } catch {
                print(error.localizedDescription)
                self.stockWatchlist = []
            }
        }
    }
    
    private func saveWatchlistItems(){
        Task { [weak self] in
            guard let self = self else{ return }
            do{
                try await self.tickerList.save(self.stockWatchlist)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func removeWatchlistItems(atOffsets offsets: IndexSet){
        stockWatchlist.remove(atOffsets: offsets)
    }
    
    func isAddedToWatchList(item: Ticker) -> Bool{
        stockWatchlist.first { $0.symbol == item.symbol } != nil
    }
    // don't just explicitly accept one parameter
    func toggleWatchlistItem(_ item: Ticker) {
        if isAddedToWatchList(item: item){
            removeFromAdded(item: item)
        }
    }
    
    private func removeFromAdded(item: Ticker){
        guard let index = stockWatchlist.firstIndex(where: { $0.symbol == item.symbol }) else { return }
        stockWatchlist.remove(at: index)
    }
    
    private func addToWatchList(item: Ticker){
        stockWatchlist.append(item)
    }
}
