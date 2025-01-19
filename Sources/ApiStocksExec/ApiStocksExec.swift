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
            
            
    
        
            
            let chart = try await api.fetchChartData(symbol: "AMRN", interval: .fifteenMin, range: .oneDay, region: "US")
            
            print(chart ?? "Not Found")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
