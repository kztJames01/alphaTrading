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
                "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]
        
        let urlString = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/"
        
        guard let url = URL(string: urlString) else{
            print("Invalid URL.")
            return
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let (data, response) = try! await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode){
                print("HTTP Error: \(httpResponse.statusCode)")
            }
            
            let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
            
            print(quoteResponse)
        } catch{
            print("An error occured: \(error.localizedDescription)")
        }
        
        
    }
}
