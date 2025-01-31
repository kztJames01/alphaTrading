//
//  MainView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import SwiftUI
import ApiStocks

struct MainView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM: QuoteViewModel
    @StateObject var searchVM: SearchViewModel
    
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay { overlayView }
            .toolbar{
                titleToolBar
                attributionToolBar
            }
            .searchable(text: $searchVM.query)
            .refreshable {
                await quotesVM.fetchQuotes(tickers: appVM.stockWatchlist)
            }
            .task(id: appVM.stockWatchlist) { await quotesVM.fetchQuotes(tickers: appVM.stockWatchlist)}
    }
    
    private var tickerListView: some View{
        List{
            ForEach(appVM.stockWatchlist) {
                item in TickerListRowView(data:
                        .init(symbol: item.symbol, name: item.name, price: quotesVM.priceForTicker(item), type: .main))
                .contentShape(Rectangle())
                .onTapGesture {
                    
                }
            } .onDelete{ appVM.removeWatchlistItems(atOffsets: $0)
            }
        }.padding(.bottom)
    }
    
    @ViewBuilder
    private var overlayView: some View{
        if appVM.stockWatchlist.isEmpty{
            EmptyStateView(text: appVM.emptyTickersText)
        }
        if searchVM.isSearching{
            SearchView(searchVM: searchVM)
        }
    }
    
    private var titleToolBar: some ToolbarContent{
        #if os(macOS)
        ToolbarItem(placement: .navigation){
            HStack(alignment: .leading, spacing: -4){
                Text(appVM.titleText)
                Text(appVM.subtitleText).foregroundColor(Color(.systemGray))
            }.font(.title2.weight(.heavy))
                .padding(.bottom)
            
        }
        #else
        ToolbarItem(placement: .navigationBarLeading){
            HStack(alignment: .top, spacing: -2){
                Text(appVM.titleText)
                Spacer()
                Text(appVM.subtitleText).foregroundColor(Color(.systemGray))
            }.font(.title2.weight(.heavy))
                .padding(.bottom)
        }
        #endif
    }
    
    private var attributionToolBar: some ToolbarContent{
        ToolbarItem(placement: .bottomBar){
            HStack{
                Button{
                    appVM.openYahooFinance()
                } label: {
                    Text(appVM.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(.systemGray))
                } .buttonStyle(.plain)
    
            }
        }
    }
}

struct MainView_Previews: PreviewProvider{
    @StateObject static var appVM: AppViewModel = {
        var mock = MockTickerList()
        mock.stubbedLoad = {Ticker.stubs}
        return AppViewModel(tickerList: mock)
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        var mock = MockTickerList()
        mock.stubbedLoad = { [] }
        return AppViewModel(tickerList: mock)
        
    }()
    
    @StateObject static var quotesVM: QuoteViewModel = {
        var mock = MockStocksApi()
        mock.stubbedFetchQuoteCallback = {Quote.stubs}
        return QuoteViewModel(stocksApi: mock)
    }()
    
    @StateObject static var searchVM : SearchViewModel = {
        var mock = MockStocksApi()
        mock.stubbedSearchTickerCallback = {Ticker.stubs}
        return SearchViewModel(stocksApi: mock)
    }()
    
    static var previews: some View{
        Group{
            NavigationStack{
                MainView(quotesVM: quotesVM, searchVM: searchVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Tickers")
            
            NavigationStack{
                MainView(quotesVM: quotesVM, searchVM: searchVM)
            }
            .environmentObject(emptyAppVM)
            .previewDisplayName("With Empty Tickers")
        }
    }
}
