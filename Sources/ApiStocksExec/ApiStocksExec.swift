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
            
        do{
            
            
    
            let history = try await api
                .fetchHistoryData(symbol: "AAPL", interval: .onehr, diffandsplits: false)
            print(history ?? "Not Found")
            
            
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
