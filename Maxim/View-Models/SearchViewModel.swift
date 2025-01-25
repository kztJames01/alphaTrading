//
//  SearchViewModel.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import SwiftUI
import Combine
import ApiStocks
import Foundation

class SearchViewModel: ObservableObject{
    @Published var query: String = ""
    @Published var phase: FetchPhase<[Ticker]> = .initial
        
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var tickers: [Ticker] {phase.value ?? []}
    var error: Error? {phase.error}
    var isSearching: Bool { !trimmedQuery.isEmpty }
    
    var emptyStringText: String{
        "Symbol not found for \n\"\(query)\""
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var stocksApi : StocksApi
    
    init(query: String = " ", stocksApi: StocksApi = ApiStocks() ) {
        self.query = query
        self.stocksApi = stocksApi
        
        startObserving()
    }
    
    private func startObserving(){
        $query
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink{
                _ in
                Task { [weak self] in await self?.searchTickers()}
            }
            .store(in: &cancellables)
        
        $query
            .filter { $0.isEmpty }
            .sink { [weak self] _ in self?.phase = .initial}
            .store(in: &cancellables)
    }
    
    func searchTickers() async{
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else{return}
        phase = .fetching
        
        do {
            let ticker = try? await stocksApi.searchData(search: searchQuery)
            if searchQuery != trimmedQuery { return }
            if ((ticker?.isEmpty) != nil){
                DispatchQueue.main.async{
                    self.phase = .empty
                }
            }else {
                DispatchQueue.main.async{
                    self.phase = .success(ticker!)
                }
            }
        } catch {
            if searchQuery != trimmedQuery { return }
            print(error.localizedDescription)
            DispatchQueue.main.async {
                        self.phase = .failure(error)
            }
        }
    }
    
    
    
}


