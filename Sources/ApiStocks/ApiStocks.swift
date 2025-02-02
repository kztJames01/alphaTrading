// The Swift Programming Language

import Foundation
import Firebase
import FirebaseRemoteConfig

public class FirebaseManager{
    public static func configureFirebase(){
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
                    let options = NSDictionary(contentsOfFile: path)
            print("Firebase configuration loaded: \(String(describing: options))")
                    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: path)!)
                } else {
                    print("GoogleService-Info.plist not found")
                }
    }
}

public class ApiKeyManager {
    private static let apiKeyKey = "API_KEY"
    
    // Fetch and store the API key from Firebase Remote Config
    public static func fetchAndStoreApiKey(completion: @escaping (Bool) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        settings.fetchTimeout = 10
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                remoteConfig.activate()
                let apiKey = remoteConfig["API_KEY"].stringValue
                if let apiKey = apiKey {
                    // Store the API key securely (using UserDefaults for simplicity)
                    UserDefaults.standard.set(apiKey, forKey: apiKeyKey)
                    completion(true)
                } else {
                    print("API key not found in remote config")
                    completion(false)
                }
            } else {
                print("Failed to fetch remote config: \(error?.localizedDescription ?? "Unknown Error")")
                completion(false)
            }
        }
    }
    
    // Get the stored API key (returns nil if not found)
    public static func getApiKey() -> String? {
        return UserDefaults.standard.string(forKey: apiKeyKey)
    }
}

public protocol API{
    func fetchHistoryData(symbol: String, interval: HistoryRange,diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]
    func searchData(search: String, isEquity: Bool) async throws -> [Ticker]
    func fetchQuotes(symbol:String) async throws -> [Quote]
    func fetchQuotesRawData(symbol:String) async throws -> (Data,URLResponse)
    func searchDataRawData(search:String, isEquity:Bool) async throws -> (Data, URLResponse)
    func fetchHistoryRawData(symbol:String, interval: HistoryRange,diffandsplits: Bool) async throws -> (Data, URLResponse)
    func fetchChartData(symbol:String, interval:ChartInterval, range: ChartRange, region: String) async throws -> ChartData?
    func fetchChartRawData(symbol:String, interval:ChartInterval, range: ChartRange, region: String) async throws -> (Data,URLResponse)
    
}
public struct ApiStocks:API{
    private let session =  URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder();
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    private let apiKey: String
    
    private var headersMap: [String:[String:String]]{
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
    
    public static func createInstance() async throws -> ApiStocks{
        FirebaseManager.configureFirebase()
        
        return try await withCheckedThrowingContinuation { continuation in
            ApiKeyManager.fetchAndStoreApiKey{
                success in
                if success, let apiKey = ApiKeyManager.getApiKey(){
                    continuation.resume(returning: ApiStocks(apiKey: apiKey))
                }else{
                    continuation.resume(throwing: NSError(domain: "ApiStocks", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch API successfully"]))
                }
            }
        }
    }
    private let baseURL = "https://yahoo-financial15.p.rapidapi.com"
    
    private let secondaryURL = "https://yh-finance.p.rapidapi.com"
    
    
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
    
    public func searchData(search: String,isEquity: Bool=true) async throws -> [Ticker] {
        guard let url = urlForSearch(search: search) else{
            throw ApiError.invalidURL
        }
        
        let (response, statusCode) : (SearchData, Int) = try await fetch(url: url,apiRequest: "primary")

        if let error = response.error {
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        let data = response.data ?? []
        if isEquity {
            return data.filter { ($0.typeDisp ?? "").localizedCaseInsensitiveCompare("EQUITY") == .orderedSame }
        } else{
            return data
        }
    }
    
    public func searchDataRawData(search:String, isEquity: Bool) async throws -> (Data, URLResponse){
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
    
    public func fetchChartData(symbol:String, interval:ChartInterval, range: ChartRange, region: String) async throws ->ChartData?{
        guard let url = urlForChartData(symbol: symbol, interval: ChartInterval(rawValue: interval.interval) ?? ChartInterval(rawValue: "1d")! ,range: range, region: region) else{
            throw ApiError.invalidURL
        }
        let (response, statusCode): (ChartResponse,Int) = try await fetch(url:url,apiRequest: "secondary")
        if let error = response.error{
            throw ApiError.httpStatusCodeFailed(statusCode: statusCode, errors: error)
        }
        
        return response.data?.first
    }
    
    public func fetchChartRawData(symbol:String, interval: ChartInterval,range: ChartRange, region: String) async throws -> (Data, URLResponse){
        guard let url = urlForChartData(symbol: symbol, interval: interval, range: range, region: region)else{
            throw ApiError.invalidURL
        }
        return try await session.data(from: url)
    }
    
    private func urlForChartData(symbol:String, interval: ChartInterval, range: ChartRange,region: String) -> URL?{
        guard var urlComp = URLComponents(string:"\(secondaryURL)/stock/v3/get-chart")else{
            return nil
        }
        urlComp.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "interval", value: interval.interval),
            URLQueryItem(name: "range", value: range.rawValue),
            URLQueryItem(name: "region", value: region),
            URLQueryItem(name: "includePrePost", value: "\(false)"),
            URLQueryItem(name: "useYfid", value: "\(true)"),
            URLQueryItem(name: "includeAdjustedClose", value: "\(true)"),
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
