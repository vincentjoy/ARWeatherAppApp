import Foundation

struct Config {
    static let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
}
