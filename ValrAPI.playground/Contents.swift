//
// Author: Manenga Mungandi
// Valr Public API
// Ref: https://docs.valr.com/?version=latest#cd1f0448-3da3-44cf-b00d-91edd74e7e19
//

import UIKit
import PlaygroundSupport


enum Pair { case all; case BTCZAR; case ETHZAR; case XRPZAR; }
enum RequestType: String { case GET; case POST; }
var debug = false

// Object Models

struct Balance: Codable {
    var askPrice: String?
    var baseVolume: String?
    var bidPrice: String?
    var changeFromPrevious: String?
    var created: String?
    var currencyPair: String?
    var highPrice: String?
    var lastTradedPrice: String?
    var lowPrice: String?
    var previousClosePrice: String?
}

protocol Mappable: Codable {
    init?(jsonString: String)
}

extension Mappable {
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        self = try! JSONDecoder().decode(Self.self, from: data)
        // I used force unwrap for simplicity.
        // It is better to deal with exception using do-catch.
    }
}

// Functions

func makeRequest(_ myUrl: URL, type: RequestType) -> URLRequest {
    var request = URLRequest(url: myUrl)
    request.httpMethod = type.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return request
}

func getMarketSummary(_ pair: Pair = .all) {
    print("==== Market SUMMARY ====\n\n")
    var urlStr = "https://api.valr.com/v1/public/marketsummary"
    
    if pair != .all {
        urlStr = "https://api.valr.com/v1/public/\(pair)/marketsummary"
    }
    
    let url = URL(string: urlStr)!
    
    // executing the call
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: makeRequest(url, type: .GET), completionHandler: {data, response, error -> Void in
        guard let data = data, error == nil else {
            print(error ?? "Unknown error")
            return
        }
        
        guard let contents = String(data: data, encoding: .utf8) else { return }
        do {
            let json = try JSONDecoder().decode(Balance.self, from: data)
            if (debug) { print(contents); }
            print(json);
        } catch { print(error) }
        
    })
    task.resume()
    
    PlaygroundPage.current.needsIndefiniteExecution = true
}


// Call the functions here

getMarketSummary(.XRPZAR)
