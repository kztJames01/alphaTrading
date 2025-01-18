// The Swift Programming Language

import Foundation

public protocol API{
    func fetchHistoryData(symbol: String, interval: String,diffandsplits: Bool) async throws -> MarketDataResponse?
    func searchData(query: String) async throws -> [Ticker]
    func fetchQuotes(ticker:String) async throws -> [Quote]
}
public struct ApiStocks{
    private let session =  URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder();
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    public let headers = [
        "x-rapidapi-key": "c5d836857cmshba68fc722dba282p1df907jsn5110b8a4e164",
        "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
    ]
    private let baseURL = "https://yahoo-financial15.p.rapidapi.com"
    public init() {
       
    }
    public func fetchQuotes(symbol:String) async throws -> [Quote] {
        guard let url = urlForQuotes(symbol: symbol)else{
            throw ApiError.invalidURL
        }
        let (response, statusCode) :(QuoteResponse, Int) = try await fetch(url: url)
        if let error = response.error{
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        return response.data ?? []
    }
    
    public func urlForQuotes(symbol:String) -> URL?{
        guard var urlComp = URLComponents(string: "\(baseURL)/api/v1/markets/stock/quotes")else{
            return nil
        }
        
        urlComp.queryItems = [ URLQueryItem(name: "ticker", value: symbol)]
        
        return urlComp.url
    }
    
    public func searchData(query: String) async throws -> [Ticker] {
        guard let url = urlForSearch(query: query) else{
            throw ApiError.invalidURL
        }
        
        let (response, statusCode) : (SearchData, Int) = try await fetch(url: url)
        if let error = response.error {
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        return response.data ?? []
    }
    
    public func urlForSearch(query:String) -> URL?{
        guard var urlComp = URLComponents(string: "\(baseURL)/api/v1/markets/search") else{
            return nil
        }
        
        urlComp.queryItems = [ URLQueryItem(name: query, value: query) ]
        
        return urlComp.url
    }
    
    public func fetchHistoryData(symbol:String, interval:String, diffandsplits: Bool) async throws -> MarketDataResponse?{
        guard let url = urlForHistoryData(symbol: symbol, interval: interval, diffandsplits: diffandsplits) else{
            throw ApiError.invalidURL
        }
        let (response, statusCode): (MarketDataResponse,Int) = try await fetch(url:url)
        if let error = response.error{
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        
        return response
    }
    
    private func urlForHistoryData(symbol:String, interval:String, diffandsplits: Bool) -> URL?{
        guard var urlComp = URLComponents(string:"\(baseURL)/api/v1/markets/stock/history")else{
            return nil
        }
        urlComp.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "interval", value: interval),
            URLQueryItem(name: "diffandsplits", value: "\(diffandsplits)")
        ]
        return urlComp.url
    }
    
    private func fetch<D: Decodable>(url:URL) async throws -> (D,Int){
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        let statusCode = try validateHTTPResponse(response: response)
        return (try jsonDecoder().decode(D.self, from: data), statusCode)
    }
    
    private func validateHTTPResponse(response: URLResponse) throws -> Int{
        guard let httpResponse = response as? HTTPURLResponse else{
            throw ApiError.invalidResponseType
        }
        
        guard 200...299 ~= httpResponse.statusCode ||
                400...499 ~= httpResponse.statusCode else{
            throw ApiError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, errors: nil)
        }
        
        return httpResponse.statusCode
    }
}
