import Foundation

@Observable
final class WeatherAppViewModel {
    
    private var networkManager: NetworkManager
    var weatherDetails: WeatherDetails?
    
    init() {
        networkManager = NetworkManager(baseURL: Config.baseUrl)
    }
    
    func fetchWeatherDetails(for city: String) {
        Task {
            do {
                let location = try await locationData(for: city)
                let weather = try await weatherData(for: location.key)
                self.weatherDetails = WeatherDetails(location: location, weather: weather)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func locationData(for city: String) async throws -> Location {
        let endPoint: String = "locations/v1/cities/search?apikey=\(Config.apiKey)&q=\(city)"
        let locationDetails: [Location] = try await networkManager.request(endpoint: endPoint, method: .get)
        if let firstLocation = locationDetails.first {
            return firstLocation
        }
        throw NetworkError.invalidResponse
    }
    
    private func weatherData(for cityKey: String) async throws -> Weather {
        let endPoint: String = "currentconditions/v1/\(cityKey)?apikey=\(Config.apiKey)"
        let weatherDetails: [Weather] = try await networkManager.request(endpoint: endPoint, method: .get)
        if let firstWeatherDetails = weatherDetails.first {
            return firstWeatherDetails
        }
        throw NetworkError.invalidResponse
    }
}
