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
    
    static func main() async{
            
        do{
            let api = ApiStocks()
            let quote = try await api.fetchQuotes(symbol: "AAPL")
            print(quote)
            
            let searchResp = try await api.searchData(search: "AAPL")
            print(searchResp)
        
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
