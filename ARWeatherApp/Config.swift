import Foundation

struct Config {
    static let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    static let baseUrl: String = "http://dataservice.accuweather.com"
}
