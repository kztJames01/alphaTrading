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
    }
    
    private var titleToolBar: some ToolbarContent{
        #if os(macOS)
        ToolbarItem(placement: .navigation){
            VStack(alignment: .leading, spacing: 4){
                Text(appVM.titleText)
                Text(appVM.subtitleText).foregroundColor(Color(.systemGray))
            }.font(.title2.weight(.heavy))
                .padding(.vertical,20)
            
        }
        #else
        ToolbarItem(placement: .navigationBarLeading){
            VStack(alignment: .leading, spacing: 4){
                Text(appVM.titleText)
                Text(appVM.subtitleText).foregroundColor(Color(.systemGray))
            }.font(.title2.weight(.heavy))
                .padding(.vertical,10)
        }
        #endif
    }
    
    private var attributionToolBar: some ToolbarContent{
        ToolbarItem(placement: .automatic){
            HStack{
                Button{
                    
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
        let vm = AppViewModel()
        vm.stockWatchlist = Ticker.stubs
        return vm
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        let vm = AppViewModel()
        vm.stockWatchlist = []
        return vm
    }()
    
    @StateObject static var quotesVM: QuoteViewModel = {
        let vm = QuoteViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    
    @StateObject static var searchVM : SearchViewModel = {
        let vm = SearchViewModel()
        vm.query = ""
        return vm
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
