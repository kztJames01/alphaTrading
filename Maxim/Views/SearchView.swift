//
//  SearchView.swift
//  Maxim
//
//  Created by Kaung Zaw Thant on 1/25/25.
//

import SwiftUI
import ApiStocks
struct SearchView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuoteViewModel()
    @StateObject var searchVM: SearchViewModel
    
    
    var body: some View {
        List(searchVM.tickers){
            item in TickerListRowView(data: .init(symbol: item.symbol, name: item.name, price: quotesVM.priceForTicker(item), type: .search(isSaved: appVM.isAddedToWatchList(item: item), onButtonTapped: {
                Task{
                    @MainActor in
                    appVM.toggleWatchlistItem(item)
                }
            }))).contentShape(Rectangle())
                .onTapGesture {
                    
                }
        }
        .listStyle(.plain)
        .refreshable { await quotesVM.fetchQuotes(tickers: searchVM.tickers)}
        .task(id: searchVM.tickers) {
            await quotesVM.fetchQuotes(tickers: searchVM.tickers)
        }
        .overlay {listSearchOverlay}
    }
    
    @ViewBuilder
    private var listSearchOverlay: some View{
        switch searchVM.phase {
        case .failure(let error):
            ErrorStateView(error: error.localizedDescription){
                Task { await searchVM.searchTickers()}
            }
        case .empty:
            EmptyStateView(text: searchVM.emptyStringText)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    
    }
}

struct SearchView_Previews: PreviewProvider {
    
    @StateObject static var stubbedSearchVM: SearchViewModel = {
        var mock = MockStocksApi()
        mock.stubbedSearchTickerCallback = { Ticker.stubs }
        return SearchViewModel(query: "Apple", stocksApi: mock)
    }()
    
    @StateObject static var emptySearchVM: SearchViewModel = {
        var mock = MockStocksApi()
        mock.stubbedSearchTickerCallback = { [] }
        return SearchViewModel(query: "Theranos", stocksApi: mock)
    }()
    
    @StateObject static var loadingSearchVM: SearchViewModel = {
        var mock = MockStocksApi()
        mock.stubbedSearchTickerCallback = { await withCheckedContinuation {_ in} }
        return SearchViewModel(query: "Apple", stocksApi: mock)
    }()
    
    @StateObject static var errorSearchVM: SearchViewModel = {
        var mock = MockStocksApi()
        mock.stubbedSearchTickerCallback = {
            throw NSError(domain: "", code: 0,userInfo: [NSLocalizedDescriptionKey: "An Error has occured"])
        }
        return SearchViewModel(query: "Apple", stocksApi: mock)
    }()
    
    @StateObject static var appVM: AppViewModel = {
        var mock = MockTickerList()
        mock.stubbedLoad = { Array(Ticker.stubs.prefix(upTo: 2)) }
        return AppViewModel(tickerList: mock)
    }()
    
    static var quotesVM: QuoteViewModel = {
        var mock = MockStocksApi()
        mock.stubbedFetchQuoteCallback = { Quote.stubs }
        return QuoteViewModel(stocksApi: mock)
    }()
    
    static var previews: some View{
        Group {
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: stubbedSearchVM)
            }.searchable(text: $stubbedSearchVM.query)
                .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: stubbedSearchVM)
            }.searchable(text: $emptySearchVM.query)
                .previewDisplayName("Empty")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: stubbedSearchVM)
            }.searchable(text: $loadingSearchVM.query)
                .previewDisplayName("Loading...")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: stubbedSearchVM)
            }.searchable(text: $errorSearchVM.query)
                .previewDisplayName("Error 404")
        }.environmentObject(appVM)
    }
}
