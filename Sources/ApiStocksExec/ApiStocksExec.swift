//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/13/25.
//
import Foundation
import ApiStocks
@main
struct ApiStocksExec{
    private static let api = ApiStocks()
    static func main() async{
        let headers = [
            "x-rapidapi-key": "c5d836857cmshba68fc722dba282p1df907jsn5110b8a4e164",
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
        ]
        
        let quoteURL = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/quotes?ticker=AAPL"
        
        let searchURL = "https://yahoo-fianance15.p.rapidapi.com/api/v1/markets/search?search=AA"
        
        let chartURL = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/history?symbol=AAPL&interval=3mo&diffandsplits=false"
            
        do{
            
            let history = try? await api
                .fetchHistoryData(symbol: "AAPL", interval: "1mo", diffandsplits: false)
            print(history ?? "Not Found")
            
            let searchTickers = try? await api
                .searchData(query: "AA")
            print(searchTickers ?? [])
            
            let quote = try? await api
                .fetchQuotes(symbol: "AAPL")
            print(quote ?? [])
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
