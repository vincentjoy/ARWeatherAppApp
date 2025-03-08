import Foundation

struct WeatherDetails {
    let localizedName: String
    let weatherText: String
    let temperature: String
}

extension WeatherDetails {
    init(location: Location, weather: Weather) {
        self.localizedName = location.localizedName
        self.weatherText = weather.weatherText
        self.temperature = "\(weather.temperature.metric.value)°\(weather.temperature.metric.unit)"
    }
}

extension WeatherDetails: CustomStringConvertible {
    var description: String {
        return "\(localizedName) weather is \(weatherText) and temperature is \(temperature))"
    }
}
