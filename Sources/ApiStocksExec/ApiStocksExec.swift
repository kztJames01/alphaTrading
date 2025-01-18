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
        let headers = [
            "x-rapidapi-key": "c5d836857cmshba68fc722dba282p1df907jsn5110b8a4e164",
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
        ]
        
        let quoteURL = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/quotes?ticker=AAPL"
        
        let searchURL = "https://yahoo-fianance15.p.rapidapi.com/api/v1/markets/search?search=AA"
        
        let chartURL = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/history?symbol=AAPL&interval=3mo&diffandsplits=false"
            
        
        if let quoteResponse = await fetchRequest(urlString: quoteURL, headers: headers, decodeType: QuoteResponse.self){
            print("Quote Works")
        }
        print("            ")
        if let searchResponse = await fetchRequest(urlString: searchURL, headers: headers, decodeType: SearchTicker.self){
            print("Search Works")
        }
        
        print("         ")
        
        if let chartResponse = await fetchRequest(urlString: chartURL, headers: headers, decodeType: MarketDataResponse.self){
            print(chartResponse)
        }
        
    }
    static func fetchRequest<T: Decodable>(urlString: String, headers: [String: String], decodeType: T.Type) async -> T?{
        
        guard let url = URL(string: urlString) else{
            print("Invalid URL.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try! await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...499).contains(httpResponse.statusCode){
                print("URL not found, HTTP Error: \(httpResponse.statusCode)")
                return nil
            }
            
            return try JSONDecoder().decode(decodeType, from: data)
        } catch{
            print("An error occured: \(error.localizedDescription)")
            return nil
        }
    }
}
