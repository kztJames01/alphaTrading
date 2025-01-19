// The Swift Programming Language

import Foundation

public protocol API{
    func fetchHistoryData(symbol: String, interval: HistoryRange,diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]
    func searchData(search: String) async throws -> [Ticker]
    func fetchQuotes(symbol:String) async throws -> [Quote]
    func fetchQuotesRawData(symbol:String) async throws -> (Data,URLResponse)
    func searchDataRawData(search:String) async throws -> (Data, URLResponse)
    func fetchHistoryRawData(symbol:String, interval: HistoryRange,diffandsplits: Bool) async throws -> (Data, URLResponse)
}
public struct ApiStocks:API{
    private let session =  URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder();
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    
    private var headersMap: [String:[String:String]]{
        guard let apiKey = ProcessInfo.processInfo.environment["Rapid_API_KEY"] else{
            fatalError("API Key not found in environment variables")
        }
        return [
            "primary":[
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
        ],
            "secondary":[
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "yh-finance.p.rapidapi.com"
        ],
        ]
    }
    
    private let baseURL = "https://yahoo-financial15.p.rapidapi.com"
    public init() {
    }
    public func fetchQuotes(symbol:String) async throws -> [Quote] {
        guard let url = urlForQuotes(symbol: symbol)else{
            throw ApiError.invalidURL
        }
        let (response, statusCode) :(QuoteResponse, Int) = try await fetch(url: url,apiRequest: "primary")
        if let error = response.error{
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        return response.data ?? []
    }
    
    public func fetchQuotesRawData(symbol:String) async throws -> (Data, URLResponse){
        guard let url = urlForQuotes(symbol: symbol ) else{
            throw ApiError.invalidURL
        }
        return try await session.data(from: url)
    }
    
    private func urlForQuotes(symbol:String) -> URL?{
        guard var urlComp = URLComponents(string: "\(baseURL)/api/v1/markets/stock/quotes")else{
            return nil
        }
        
        urlComp.queryItems = [ URLQueryItem(name: "ticker", value: symbol)]
        
        return urlComp.url
    }
    
    public func searchData(search: String) async throws -> [Ticker] {
        guard let url = urlForSearch(search: search) else{
            throw ApiError.invalidURL
        }
        
        let (response, statusCode) : (SearchData, Int) = try await fetch(url: url,apiRequest: "primary")

        if let error = response.error {
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        return response.data ?? []
    }
    
    public func searchDataRawData(search:String) async throws -> (Data, URLResponse){
        guard let url = urlForSearch(search: search) else{
            throw ApiError.invalidURL
        }
        return try await session.data(from: url)
    }
    
    private func urlForSearch(search:String) -> URL?{
        guard var urlComp = URLComponents(string: "\(baseURL)/api/v1/markets/search") else{
            return nil
        }
        
        urlComp.queryItems = [ URLQueryItem(name: "search", value: search) ]
        
        return urlComp.url
    }
    
    public func fetchHistoryData(symbol:String, interval:HistoryRange, diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]{
        guard let url = urlForHistoryData(symbol: symbol, interval: HistoryRange(rawValue: interval.interval) ?? HistoryRange(rawValue: "1d")!, diffandsplits: diffandsplits) else{
            throw ApiError.invalidURL
        }
        let (response, statusCode): (MarketDataResponse,Int) = try await fetch(url:url,apiRequest: "primary")
        if let error = response.error{
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        
        return [(response.metaData!, response.data!)]
    }
    
    public func fetchHistoryRawData(symbol:String, interval: HistoryRange,diffandsplits: Bool) async throws -> (Data, URLResponse){
        guard let url = urlForHistoryData(symbol: symbol, interval: interval, diffandsplits: diffandsplits) else{
            throw ApiError.invalidURL
        }
        return try await session.data(from: url)
    }
    
    private func urlForHistoryData(symbol:String, interval: HistoryRange, diffandsplits: Bool) -> URL?{
        guard var urlComp = URLComponents(string:"\(baseURL)/api/v1/markets/stock/history")else{
            return nil
        }
        urlComp.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "interval", value: interval.interval),
            URLQueryItem(name: "diffandsplits", value: "\(diffandsplits)")
        ]
        return urlComp.url
    }
    
    private func fetch<D: Decodable>(url:URL,apiRequest: String) async throws -> (D,Int){
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = try await apiRequestType(apiRequest: apiRequest)
       
        
        let (data, response) = try await session.data(for:request)
        let statusCode = try validateHTTPResponse(response: response)

        do {
            let decodedData = try jsonDecoder().decode(D.self, from: data)
                return (decodedData, statusCode)
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode raw data")")
                throw error
            }
    }
    
    private func apiRequestType(apiRequest: String) async throws -> [String:String]{
        guard let headers = headersMap[apiRequest] else{
            throw NSError(domain: "Invalid API Request", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(apiRequest) API Request not working"])
        }
        return headers
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
