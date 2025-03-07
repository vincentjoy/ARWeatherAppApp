import Foundation

struct Location: Codable {
    let key: String
    let localizedName, englishName: String
    let primaryPostalCode: String
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case primaryPostalCode = "PrimaryPostalCode"
    }
}
