//
//  MainView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import SwiftUI
import ApiStocks

struct MainView: View {
    
    @EnvironmentObject var appVm: AppViewModel
    @StateObject var quotesVM: QuoteViewModel
    @StateObject var searchVM: SearchViewModel
    
    var body: some View {
        VStack{
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello World")
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider{
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = []
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
